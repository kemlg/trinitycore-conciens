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

#include "mongo/client/dbclient.h"
#include "mongo/bson/bson.h"

template <typename T>
class SynchronisedQueue
{
public:

    SynchronisedQueue()
    {
        RequestToEnd = false;
        EnqueueData = true;
    }
    void Enqueue(const T& data)
    {
        boost::unique_lock<boost::mutex> lock(m_mutex);

        if(EnqueueData)
        {
            m_queue.push(data);
            m_cond.notify_one();
        }
    }

    bool TryDequeue(T& result)
    {
        boost::unique_lock<boost::mutex> lock(m_mutex);

        while (m_queue.empty() && (! RequestToEnd))
        {
            m_cond.wait(lock);
        }

        if( RequestToEnd )
        {
            DoEndActions();
            return false;
        }

        result= m_queue.front(); m_queue.pop();

        return true;
    }

    void StopQueue()
    {
        RequestToEnd =  true;
        Enqueue(NULL);
    }

    int Size()
    {
        boost::unique_lock<boost::mutex> lock(m_mutex);
        return m_queue.size();
    }

private:

    void DoEndActions()
    {
        EnqueueData = false;

        while (!m_queue.empty())
        {
            m_queue.pop();
        }
    }

    std::queue<T> m_queue;              // Use STL queue to store data
    boost::mutex m_mutex;               // The mutex to synchronise on
    boost::condition_variable m_cond;   // The condition to wait for

    bool RequestToEnd;
    bool EnqueueData;
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

mongo::DBClientConnection           connEvents(true, NULL, NULL);
mongo::DBClientConnection           connActions(true, NULL, NULL);
const char*                         endMsg          = "\n";
const int                           port_out        = 6969;
const int                           port_in         = 6970;
const char*                         ebServerHost	= "conciens.mooo.com";
struct hostent*                     host;
struct sockaddr_in                  server_addr;
SynchronisedQueue<mongo::BSONObj>	queue;

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

void* processActions(void *)
{
  while(true)
  {
    try
    {
      mongo::auto_ptr<mongo::DBClientCursor> cursor =
        connActions.query("conciens.actions", mongo::BSONObj());

      while(cursor->more())
      {
        mongo::BSONObj action = cursor->next();
        connActions.remove("conciens.actions", action);

        std::string actionId = action["action-id"].String();
        // TC_LOG_INFO("server.loading", "Action arrived: %s", actionId.c_str());
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
      }
      sleep(1);
    }
    catch(const mongo::DBException& ex)
    {
      std::cout << "Reconnecting due to DBException: " << ex.what() << "//" << ex.toString() << std::endl;
      sleep(0.1);
    }
  }

  return NULL;
}

bool checkPortTCP(short int dwPort, const char *ipAddressStr)
{
    struct sockaddr_in server_addr;
    int sock;
    struct hostent*		host;
    struct timeval timeout;
    timeout.tv_sec = 1;
    timeout.tv_usec = 0;

    host = gethostbyname(ipAddressStr);
    sock = (int) socket(AF_INET, SOCK_STREAM, 0);

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr = *((struct in_addr *) host->h_addr);
    bzero(&(server_addr.sin_zero), 8);
    server_addr.sin_port = htons(dwPort);
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout));
    int result = connect(sock, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));

    close(sock);

    if (result == 0) {
        return true;
    }
    else return false;
}

void* processMessages(void *)
{
    int size;
    std::vector<mongo::BSONObj> vEvents;
    mongo::BSONObj b;

    while(true)
    {
      try
      {
        size = queue.Size();
        // TC_LOG_INFO("server.loading", "Sending events, size: %d", size);
        for(int i = 0 ; i < size ; i++) {
          bool correct = queue.TryDequeue(b);
          if(correct) {
            vEvents.push_back(b);
            if(i % 20000 == 0)
            {
              connEvents.insert("conciens.events", vEvents);
              vEvents.clear();
            }
          }
        }

        connEvents.insert("conciens.events", vEvents);
        vEvents.clear();

        sleep(1);
      }
      catch(const mongo::DBException& ex)
      {
        std::cout << "Reconnecting due to DBException: " << ex.what() << "//" << ex.toString() << std::endl;
        vEvents.clear();
        sleep(0.1);
      }
    }

    return NULL;
}

EventBridge::EventBridge()
{
    pthread_t thread1, thread2;

    TC_LOG_INFO("server.loading", "EventBridge: Starting EventBridge...");
    
    connEvents.connect("localhost");
    connActions.connect("localhost");

    /* Create independent threads each of which will execute function */
    pthread_create(&thread1, NULL, processMessages, NULL);

    /* Wait till threads are complete before main continues. Unless we  */
    /* wait we run the risk of executing an exit which will terminate   */
    pthread_create(&thread2, NULL, processActions, NULL);
    /* the process and all threads before the threads have completed.   */
    //pthread_join( thread1, NULL);
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
    mongo::BSONObjBuilder builder;

    std::time_t curtime = sWorld->GetGameTime();
    uint32 nsecs = std::difftime(curtime, basetime);

    builder.append("timestamp", nsecs);
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

    queue.Enqueue(builder.obj());
}

