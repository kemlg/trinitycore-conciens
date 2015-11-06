/*
 * EventBridge.cpp
 *
 *  Created on: 31 Jan 2011
 *      Author: sergio
 */

#include <pthread.h>
#include <stdlib.h>
#include <iostream>
#include <stdio.h>
#include <ctime>

#include "EventBridge.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "DBCStores.h"
#include "ObjectMgr.h"
#include "OutdoorPvPMgr.h"
#include "ScriptLoader.h"
#include "ScriptSystem.h"
#include "Transport.h"
#include "Vehicle.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "GossipDef.h"
#include "CreatureAI.h"
#include "Player.h"
#include "Group.h"
#include "Guild.h"
#include "Spell.h"
#include "AuctionHouseMgr.h"
#include "Channel.h"
#include "WorldPacket.h"
#include "ObjectAccessor.h"
#include "MapManager.h"
#include "DatabaseEnv.h"
#include "World.h"
#include "geohash.cpp"
#include "Config.h"

#include "mongo/bson/bson.h"
#include <amqp_tcp_socket.h>
#include <amqp.h>
#include <amqp_framing.h>

#include <queue>
#include <thread>
#include <mutex>
#include <condition_variable>

template <typename T>
class Queue
{
public:
    
    T pop()
    {
        std::unique_lock<std::mutex> mlock(mutex_);
        while (queue_.empty())
        {
            cond_.wait(mlock);
        }
        auto item = queue_.front();
        queue_.pop();
        return item;
    }
    
    void pop(T& item)
    {
        std::unique_lock<std::mutex> mlock(mutex_);
        while (queue_.empty())
        {
            cond_.wait(mlock);
        }
        item = queue_.front();
        queue_.pop();
    }
    
    void push(const T& item)
    {
        std::unique_lock<std::mutex> mlock(mutex_);
        queue_.push(item);
        mlock.unlock();
        cond_.notify_one();
    }
    
    void push(T&& item)
    {
        std::unique_lock<std::mutex> mlock(mutex_);
        queue_.push(std::move(item));
        mlock.unlock();
        cond_.notify_one();
    }
    
    size_t size()
    {
        return queue_.size();
    }
    
private:
    std::queue<T> queue_;
    std::mutex mutex_;
    std::condition_variable cond_;
};

const char* idToEventType[] = {"EVENT_TYPE_EMOTE", "EVENT_TYPE_ITEM_USE", "EVENT_TYPE_ITEM_EXPIRE",
    "EVENT_TYPE_GOSSIP_HELLO", "EVENT_TYPE_GOSSIP_SELECT", "EVENT_TYPE_GOSSIP_SELECT_CODE",
    "EVENT_TYPE_GOSSIP_HELLO_OBJECT", "EVENT_TYPE_GOSSIP_SELECT_OBJECT", "EVENT_TYPE_GOSSIP_SELECT_CODE_OBJECT",
    "EVENT_TYPE_QUEST_ACCEPT", "EVENT_TYPE_QUEST_SELECT", "EVENT_TYPE_QUEST_STATUS_CHANGE", "EVENT_TYPE_QUEST_REWARD",
    "EVENT_TYPE_GET_DIALOG_STATUS", "EVENT_TYPE_QUEST_ACCEPT_OBJECT", "EVENT_TYPE_QUEST_SELECT_OBJECT",
    "EVENT_TYPE_QUEST_COMPLETE_OBJECT", "EVENT_TYPE_QUEST_REWARD_OBJECT", "EVENT_TYPE_GET_DIALOG_STATUS_OBJECT",
    "EVENT_TYPE_OBJECT_CHANGED", "EVENT_TYPE_OBJECT_UPDATE", "EVENT_TYPE_AREA_TRIGGER", "EVENT_TYPE_WEATHER_CHANGE",
    "EVENT_TYPE_WEATHER_UPDATE", "EVENT_TYPE_PVP_KILL", "EVENT_TYPE_CREATURE_KILL", "EVENT_TYPE_KILLED_BY_CREATURE",
    "EVENT_TYPE_MONEY_CHANGED", "EVENT_TYPE_LEVEL_CHANGED", "EVENT_TYPE_CREATURE_UPDATE", "EVENT_TYPE_PLAYER_UPDATE",
    "EVENT_TYPE_ITEM_REMOVE", "EVENT_TYPE_GAME_OBJECT_DESTROYED", "EVENT_TYPE_GAME_OBJECT_DAMAGED",
    "EVENT_TYPE_GAME_OBJECT_LOOT_STATE_CHANGED", "EVENT_TYPE_AUCTION_ADD", "EVENT_TYPE_AUCTION_REMOVE",
    "EVENT_TYPE_AUCTION_SUCCESSFUL" ,"EVENT_TYPE_AUCTION_EXPIRE", "EVENT_TYPE_PLAYER_CHAT",
    "EVENT_TYPE_PLAYER_SPELL_CAST", "EVENT_TYPE_PLAYER_LOGIN", "EVENT_TYPE_PLAYER_LOGOUT",
    "EVENT_TYPE_PLAYER_CREATE", "EVENT_TYPE_PLAYER_DELETE", "EVENT_TYPE_PLAYER_SAVE",
    "EVENT_TYPE_PLAYER_UPDATE_ZONE", "EVENT_TYPE_HEAL", "EVENT_TYPE_DAMAGE"
};

amqp_connection_state_t connEvents  = amqp_new_connection();
amqp_connection_state_t   connActions = amqp_new_connection();
amqp_basic_properties_t propsExpiration, propsNormal;
Queue<std::pair<mongo::BSONObj, amqp_basic_properties_t *>> q;

static bool removeQuestFromDB() {
    SQLTransaction trans = WorldDatabase.BeginTransaction();
    PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_QUEST_CREATURE_STARTER);
    stmt->setInt32(0, 999999);
    trans->Append(stmt);
    WorldDatabase.DirectCommitTransaction(trans);

    trans = WorldDatabase.BeginTransaction();
    stmt = WorldDatabase.GetPreparedStatement(WORLD_DEL_QUEST_CREATURE_ENDER);
    stmt->setInt32(0, 999999);
    trans->Append(stmt);
    WorldDatabase.DirectCommitTransaction(trans);

    trans = WorldDatabase.BeginTransaction();
    WorldDatabase.GetPreparedStatement(WORLD_DEL_QUEST_TEMPLATE);
    stmt->setInt32(0, 999999);
    trans->Append(stmt);
    WorldDatabase.DirectCommitTransaction(trans);

    return true;
}

static bool addQuestToDB() {
    SQLTransaction trans = WorldDatabase.BeginTransaction();

    PreparedStatement* stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_QUEST_TEMPLATE);
    stmt->setInt32(0, 999999);
    stmt->setInt8(1, 2);
    stmt->setInt8(2, 1);
    stmt->setInt8(3, 1);
    stmt->setInt8(4, 80);
    stmt->setInt32(26, 80000000);
    stmt->setString(82, "Title");
    stmt->setString(83, "Objectives.");
    stmt->setString(84, "Details.");
    stmt->setString(85, "End text.");
    stmt->setString(86, "Completed.");
    stmt->setString(87, "Offer reward.");
    stmt->setString(89, "Completed.");
    stmt->setInt32(105, 6260);
    stmt->setInt8(111, 2);
    trans->Append(stmt);

    stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_QUEST_CREATURE_STARTER);
    stmt->setInt16(0, 295);
    stmt->setInt32(1, 999999);
    trans->Append(stmt);

    stmt = WorldDatabase.GetPreparedStatement(WORLD_INS_QUEST_CREATURE_ENDER);
    stmt->setInt16(0, 295);
    stmt->setInt32(1, 999999);
    trans->Append(stmt);

    WorldDatabase.DirectCommitTransaction(trans);

    return true;
}

static bool reloadAllQuests()
{
    TC_LOG_INFO("misc", "Re-Loading Quest Area Triggers...");
    sObjectMgr->LoadQuestAreaTriggers();
    TC_LOG_INFO("misc", "DB table `areatrigger_involvedrelation` (quest area triggers) reloaded.");
    TC_LOG_INFO("misc", "Re-Loading Quest POI ..." );
    sObjectMgr->LoadQuestPOI();
    TC_LOG_INFO("misc", "DB Table `quest_poi` and `quest_poi_points` reloaded.");
    TC_LOG_INFO("misc", "Re-Loading Quest Templates...");
    sObjectMgr->LoadQuests();
    TC_LOG_INFO("misc", "DB table `quest_template` (quest definitions) reloaded.");
    //
    /// dependent also from `gameobject` but this table not reloaded anyway
    TC_LOG_INFO("misc", "Re-Loading GameObjects for quests...");
    sObjectMgr->LoadGameObjectForQuests();
    TC_LOG_INFO("misc", "Data GameObjects for quests reloaded.");

    TC_LOG_INFO("misc", "Re-Loading Quests Relations...");
    sObjectMgr->LoadQuestStartersAndEnders();
    TC_LOG_INFO("misc", "DB tables `*_queststarter` and `*_questender` reloaded.");

    return true;
}

static bool updateCreature(uint64 guid)
{
    const SessionMap& sessions = sWorld->GetAllSessions();

    for(std::unordered_map<uint32, WorldSession* >::const_iterator itr = sessions.begin();itr != sessions.end();++itr)
    {
        WorldSession* ws = itr->second;
        if(ws->GetPlayer())
        {
            Creature *obj = sObjectAccessor->GetCreatureOrPetOrVehicle(*ws->GetPlayer(), ObjectGuid(guid));
            int phaseMask = obj->GetPhaseMask();
            int tmpPhaseMask = phaseMask == 2 ? 3 : 2;
            obj->SendUpdateToPlayer(ws->GetPlayer());
            obj->SetPhaseMask(tmpPhaseMask, true);
            obj->SendUpdateToPlayer(ws->GetPlayer());
            obj->SetPhaseMask(phaseMask, true);
            obj->SendUpdateToPlayer(ws->GetPlayer());
        }
    }

    return true;
}

static bool createGameObject(int objectId, int mapId, double x, double y, double z, double o)
{
    char* spawntimeSecs = strtok(NULL, " ");
    const GameObjectTemplate* objectInfo = sObjectMgr->GetGameObjectTemplate(objectId);

    if (!objectInfo)
    {
        TC_LOG_INFO("server.loading", "LANG_GAMEOBJECT_NOT_EXIST %d", objectId);
        return false;
    }

    if (objectInfo->displayId && !sGameObjectDisplayInfoStore.LookupEntry(objectInfo->displayId))
    {
        // report to DB errors log as in loading case
        TC_LOG_ERROR("sql.sql", "Gameobject (Entry %u GoType: %u) have invalid displayId (%u), not spawned.", objectId, objectInfo->type, objectInfo->displayId);
        TC_LOG_INFO("server.loading", "LANG_GAMEOBJECT_HAVE_INVALID_DATA %d", objectId);
        return false;
    }

    Map* map = sMapMgr->FindMap(mapId, 0);

    GameObject* object = new GameObject;
    uint32 guidLow = sObjectMgr->GenerateLowGuid(HIGHGUID_GAMEOBJECT);

    if (!object->Create(guidLow, objectInfo->entry, map, uint32(PHASEMASK_ANYWHERE), x, y, z, o, 0.0f, 0.0f, 0.0f, 0.0f, 0, GO_STATE_READY))
    {
        delete object;
        return false;
    }

    if (spawntimeSecs)
    {
        uint32 value = atoi((char*)spawntimeSecs);
        object->SetRespawnTime(value);
    }

    // fill the gameobject data and save to the db
    object->SaveToDB(map->GetId(), (1 << map->GetSpawnMode()), uint32(PHASEMASK_ANYWHERE));
    // delete the old object and do a clean load from DB with a fresh new GameObject instance.
    // this is required to avoid weird behavior and memory leaks
    delete object;

    object = new GameObject();
    // this will generate a new guid if the object is in an instance
    if (!object->LoadGameObjectFromDB(guidLow, map))
    {
        delete object;
        return false;
    }

    /// @todo is it really necessary to add both the real and DB table guid here ?
    sObjectMgr->AddGameobjectToGrid(guidLow, sObjectMgr->GetGOData(guidLow));

    TC_LOG_INFO("server.loading", "LANG_GAMEOBJECT_ADD %d %s %d %f %f %f", objectId, objectInfo->name.c_str(), guidLow, x, y, z);
    return true;
}

void* processMessages(void *)
{
    std::pair<mongo::BSONObj, amqp_basic_properties_t *> pair;
    
    while(true)
    {
        pair = q.pop();
        mongo::BSONObj bobj = pair.first;
        amqp_basic_properties_t *propsCorrect = pair.second;
        
        amqp_bytes_t message_bytes;
        message_bytes.len = bobj.objsize();
        message_bytes.bytes = (void *)bobj.objdata();
        
        amqp_basic_publish(connEvents,
                           1,
                           amqp_cstring_bytes("amq.direct"),
                           amqp_cstring_bytes("conciens.events"),
                           0,
                           0,
                           propsCorrect,
                           message_bytes);
    }
}

void* processActions(void *)
{
    amqp_bytes_t queuename;
    amqp_queue_declare_ok_t *r = amqp_queue_declare(connActions, 2,
                                                    amqp_empty_bytes,
                                                    0, 0, 0, 1,
                                                    amqp_empty_table);
    queuename = amqp_bytes_malloc_dup(r->queue);
    amqp_queue_bind(connActions, 2, queuename, amqp_cstring_bytes("amq.direct"),
                    amqp_cstring_bytes("conciens.actions"),
                    amqp_empty_table);
    amqp_basic_consume(connActions, 2, queuename, amqp_empty_bytes, 0, 0, 0, amqp_empty_table);
    
    while(true)
    {
        amqp_rpc_reply_t res;
        amqp_envelope_t envelope;
        
        amqp_maybe_release_buffers(connActions);
        
        res = amqp_consume_message(connActions, &envelope, NULL, 0);

        if (AMQP_RESPONSE_NORMAL != res.reply_type) {
          break;
        }

        mongo::BSONObj action((char *)envelope.message.body.bytes);

        std::string actionId = action["action-id"].String();
        TC_LOG_INFO("server.loading", "Action arrived: %s", actionId.c_str());
        const ObjectGuid guid(HIGHGUID_UNIT, (uint32)295, (uint32)80346);

        if(actionId.compare("create") == 0)
        {
          createGameObject(action["object-id"].Int(),
              action["map-id"].Int(),
              action["x"].Double(), action["y"].Double(),
              action["z"].Double(), action["o"].Double());
        }
        else if(actionId.compare("reload-quests") == 0)
        {
          reloadAllQuests();
        }
        else if(actionId.compare("add-quest") == 0)
        {
          addQuestToDB();
          reloadAllQuests();
          updateCreature(guid);
        }
        else if(actionId.compare("remove-quest") == 0)
        {
            removeQuestFromDB();
            reloadAllQuests();
            updateCreature(guid);
        }
        
        amqp_destroy_envelope(&envelope);
    }

    return NULL;
}

EventBridge::EventBridge()
{
    pthread_t thread1;
    amqp_socket_t *socket = NULL;
    std::string errmsg;
    amqp_bytes_t expiration;
    
    TC_LOG_INFO("server.loading", "EventBridge: Starting EventBridge...");
    
    expiration.bytes = (void*)"1000"; // 1 second TTL
    expiration.len = 4;
    
    propsNormal._flags = 0;
    propsNormal._flags |= AMQP_BASIC_CONTENT_TYPE_FLAG;
    propsNormal.content_type = amqp_cstring_bytes("application/bson");
    
    propsExpiration._flags = 0;
    propsExpiration._flags |= AMQP_BASIC_CONTENT_TYPE_FLAG;
    propsExpiration.content_type = amqp_cstring_bytes("application/bson");
    propsExpiration._flags |= AMQP_BASIC_EXPIRATION_FLAG;
    propsExpiration.expiration = expiration;
    
    TC_LOG_INFO("server.loading", "Connecting to RabbitMQ: [%s,%d] (user: %s)",
                sConfigMgr->GetStringDefault("RabbitMQ.host", "localhost").c_str(),
                sConfigMgr->GetIntDefault("RabbitMQ.port", 5672),
                sConfigMgr->GetStringDefault("RabbitMQ.user", "guest").c_str());
    
    socket = amqp_tcp_socket_new(connEvents);
    amqp_socket_open(socket,
                     sConfigMgr->GetStringDefault("RabbitMQ.host", "localhost").c_str(),
                     sConfigMgr->GetIntDefault("RabbitMQ.port", 5672));
    amqp_login(connEvents, "/", 0, 131072, 0, AMQP_SASL_METHOD_PLAIN,
               sConfigMgr->GetStringDefault("RabbitMQ.user", "guest").c_str(),
               sConfigMgr->GetStringDefault("RabbitMQ.pass", "guest").c_str());
    amqp_channel_open(connEvents, 1);
    
    socket = amqp_tcp_socket_new(connActions);
    amqp_socket_open(socket,
                     sConfigMgr->GetStringDefault("RabbitMQ.host", "localhost").c_str(),
                     sConfigMgr->GetIntDefault("RabbitMQ.port", 5672));
    amqp_login(connActions, "/", 0, 131072, 0, AMQP_SASL_METHOD_PLAIN,
               sConfigMgr->GetStringDefault("RabbitMQ.user", "guest").c_str(),
               sConfigMgr->GetStringDefault("RabbitMQ.pass", "guest").c_str());
    amqp_channel_open(connActions, 2);
    
    pthread_create(&thread1, NULL, processActions, NULL);
}

EventBridge::~EventBridge()
{
    // TODO Auto-generated destructor stub
}

std::tm epoch_strt = {0, 0, 0, 1, 0, 70, 0, 0, -1, 0, 0};
std::time_t basetime = std::mktime(&epoch_strt);
float shiftCoordinate = 32.0 * 1600.0 / 3.0;

void EventBridge::sendEvent(const int event_type, const Player* player, const Creature* creature, const uint32 num,
                            const Item* item, const Quest* quest, const SpellCastTargets* targets,
                            const ItemTemplate* proto, const uint32 num2, const char* st, const GameObject* go,
                            const AreaTriggerEntry* area, const Weather* weather, const int state,
                            const float grade, const Unit* target, const AuctionHouseObject* ah,
                            const AuctionEntry* entry, const Group* group, const Guild* guild,
                            const Channel* channel, const Spell* spell, const Unit* actor)
{
    float	x, y, z, o, lat, lng;
    int mapId = 0;
    x = y = z = o = lat = lng = 0.0;
    char *geohash, *gharea, *ghsector, *ghbox, *ghstep;
    std::string guid;
    mongo::BSONObjBuilder builder;

    std::time_t curtime = sWorld->GetGameTime();
    uint32 nsecs = std::difftime(curtime, basetime);

    builder.append("timestamp", nsecs);
    builder.append("interval", ((int)(nsecs/900)) * 900);
    builder.append("event-type", idToEventType[event_type]);
    builder.append("app", idToEventType[event_type]);

    builder.append("num-values", BSON_ARRAY(num << num2));

    if(st != NULL) {
        // TC_LOG_INFO("server.loading", "%s", st);
        builder.append("string-value", st);
    }

    if(area != NULL) {
        builder.append("area", area->id);
    }

    if(player != NULL) {
        player->GetPosition(x, y, z, o);
        mapId = player->GetMapId();
        guid = std::to_string(player->GetEntry());
        builder.append("player",
                       BSON("guid" << player->GetEntry() <<
                       "name" << player->GetName().c_str() <<
                       "level" << player->getLevel() <<
                       "description" << player->ToString().c_str() <<
                       "x" << x <<
                       "y" << y <<
                       "z" << z <<
                       "o" << o <<
                       "map"<< mapId));
    }

    if(actor != NULL) {
        actor->GetPosition(x, y, z, o);
        mapId = actor->GetMapId();
        builder.append("actor",
                       BSON("guid" << actor->GetEntry() <<
                       "name" << actor->GetName().c_str() <<
                       "level" << actor->getLevel() <<
                       "description" << actor->ToString().c_str() <<
                       "x" << x <<
                       "y" << y <<
                       "z" << z <<
                       "o" << o <<
                       "map" << mapId));
    }

    if(target != NULL) {
        target->GetPosition(x, y, z, o);
        mapId = target->GetMapId();
        builder.append("target",
                       BSON("guid" << target->GetEntry() <<
                            "name" << target->GetName().c_str() <<
                            "level" << target->getLevel() <<
                            "x" << x <<
                            "y" << y <<
                            "z" << z <<
                            "o" << o <<
                            "map" << mapId));
    }

    if(creature != NULL) {
        creature->GetPosition(x, y, z, o);
        mapId = creature->GetMapId();
        guid = std::to_string(creature->GetEntry());
        builder.append("creature",
                       BSON("guid" << creature->GetEntry() <<
                            "name" << creature->GetName().c_str() <<
                            "level" << creature->getLevel() <<
                            "x" << x <<
                            "y" << y <<
                            "z" << z <<
                            "o" << o <<
                            "map" << mapId));
    }

    if(item != NULL) {
        builder.append("item",
                       BSON("guid" << item->GetEntry() <<
                            "name" << item->GetTemplate()->Name1.c_str()));
    }

    if(quest != NULL) {
        builder.append("quest",
                       BSON("id" << quest->GetQuestId() <<
                            "name" << quest->GetTitle().c_str() <<
                            "description" << quest->GetDetails().c_str()));
    }

    if(targets != NULL && targets->GetObjectTarget() != NULL) {
        targets->GetObjectTarget()->GetPosition(x, y, z, o);
        mapId = targets->GetObjectTarget()->GetMapId();
        builder.append("target",
                       BSON("guid" << targets->GetObjectTarget()->GetEntry() <<
                            "name" << targets->GetObjectTarget()->GetName().c_str() <<
                            "x" << x <<
                            "y" << y <<
                            "z" << z <<
                            "o" << o <<
                            "map" << mapId));
    }

    if(proto != NULL) {
        builder.append("item-template",
                       BSON("id" << proto->ItemId <<
                            "name" << proto->Name1.c_str()));
    }

    if(go != NULL) {
        go->GetPosition(x, y, z, o);
        mapId = go->GetMapId();
        guid = std::to_string(go->GetEntry());
        builder.append("game-object",
                       BSON("guid" << go->GetEntry() <<
                            "name" << go->GetName().c_str() <<
                            "x" << x <<
                            "y" << y <<
                            "z" << z <<
                            "o" << o <<
                            "map" << mapId));
    }

    if(weather != NULL) {
        builder.append("weather",
                       BSON("zone" << weather->GetZone() <<
                            "state" << state <<
                            "grade" << grade));
    }

    if(ah != NULL) {
        builder.append("auction-house-object",
                       BSON("count" << ah->Getcount()));
    }

    if(entry != NULL) {
        builder.append("auction-house-object",
                       BSON("id" << entry->itemGUIDLow <<
                            "bid" << entry->bid <<
                            "bidder" << entry->bidder));
    }

    if(group != NULL) {
        mongo::BSONArrayBuilder bGroup;
        const Group::MemberSlotList& msl = group->GetMemberSlots();
        for(std::list<Group::MemberSlot>::const_iterator it = msl.cbegin(); it != msl.cend(); it++) {
            bGroup.append(BSON("guid" << it->guid.GetEntry() <<
                               "name" << it->name.c_str()));
        }
        builder.append("group",
                       BSON("guid" << group->GetLowGUID() <<
                            "leader-guid" << group->GetLeaderGUID().GetEntry() <<
                            "leader-name" << group->GetLeaderName() <<
                            "member-list" << bGroup.arr()));
    }

    if(guild != NULL) {
        builder.append("guild",
                       BSON("id" << guild->GetId() <<
                            "name" << guild->GetName().c_str()));
    }

    if(channel != NULL) {
        builder.append("channel",
                       BSON("id" << channel->GetChannelId() <<
                            "name" << channel->GetName().c_str()));
   }

    if(spell != NULL) {
        builder.append("spell",
                       BSON("id" << spell->GetSpellInfo()->Id <<
                            "name" << *spell->GetSpellInfo()->SpellName <<
                            "family" << spell->GetSpellInfo()->SpellFamilyName));
    }

    if(x != 0 && y != 0 && z != 0) {
        lat = ((mapId * 100000.0) + y + shiftCoordinate) / 1000000.0;
        lng = ((mapId * 100000.0) + x + shiftCoordinate) / 1000000.0;
        builder.append("geometry",
                       BSON("lat" << lat <<
                            "lng" << lng));
        builder.append("lat", lat);
        builder.append("lng", lng);
        geohash = geohash_encode(lat, lng, 12);
        gharea = geohash_encode(lat, lng, 6);
        ghsector = geohash_encode(lat, lng, 7);
        ghbox = geohash_encode(lat, lng, 8);
        ghstep = geohash_encode(lat, lng, 9);
        builder.append("geohash", geohash);
        builder.append("area", gharea);
        builder.append("sector", ghsector);
        builder.append("box", ghbox);
        builder.append("step", ghstep);
        free(geohash);
        free(gharea);
        free(ghsector);
        free(ghbox);
        free(ghstep);
    }

    builder.appendDate("millis", time(0));

    amqp_basic_properties_t *propsCorrect = &propsNormal;
    if(event_type == 29 || event_type == 20) // {CREATURE,OBJECT}_UPDATE
    {
        propsCorrect = &propsExpiration;
    }
    
    const mongo::BSONObj bobj = builder.obj();
    
    // q.push(std::pair<mongo::BSONObj, amqp_basic_properties_t *>(bobj, propsCorrect));
    
    amqp_bytes_t message_bytes;
    message_bytes.len = bobj.objsize();
    message_bytes.bytes = (void *)bobj.objdata();
    
    amqp_basic_publish(connEvents,
                       1,
                       amqp_cstring_bytes("amq.direct"),
                       amqp_cstring_bytes("conciens.events"),
                       0,
                       0,
                       propsCorrect,
                       message_bytes);
}

