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
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include "restclient.h"
#include "ObjectAccessor.h"

#include <queue>
#include <boost/thread.hpp>  

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
    boost::condition_variable m_cond;            // The condition to wait for

    bool RequestToEnd;
    bool EnqueueData;
};

const char* idToEventType[] = {"EVENT_TYPE_EMOTE", "EVENT_TYPE_ITEM_USE", "EVENT_TYPE_ITEM_EXPIRE",
  "EVENT_TYPE_GOSSIP_HELLO", "EVENT_TYPE_GOSSIP_SELECT", "EVENT_TYPE_GOSSIP_SELECT_CODE",
  "EVENT_TYPE_GOSSIP_HELLO_OBJECT", "EVENT_TYPE_GOSSIP_SELECT_OBJECT", "EVENT_TYPE_GOSSIP_SELECT_CODE_OBJECT",
  "EVENT_TYPE_QUEST_ACCEPT", "EVENT_TYPE_QUEST_SELECT", "EVENT_TYPE_QUEST_COMPLETE", "EVENT_TYPE_QUEST_REWARD",
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

const char*					endMsg		= "\n";
const int					port_out	= 6969;
const int					port_in		= 6970;
const char*					ebServerHost	= "conciens.mooo.com";
struct hostent*					host;
struct sockaddr_in				server_addr;
SynchronisedQueue<rapidjson::Document*>		queue;

void processActions(rapidjson::Document& d) {
  // TODO: Do something with actions!
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

void* processMessages(void* ptr)
{
	pthread_t thread1;
	rapidjson::Document 	events, actions;
	rapidjson::Document* 	d;
	int size;
	rapidjson::Document::AllocatorType& allocator = events.GetAllocator();
	std::list<rapidjson::Document*> l;
	
	events.SetArray();
	size = queue.Size();
	// TC_LOG_INFO("server.loading", "Sending events, size: %d", size);
	for(int i=0;i<size;i++) {
	  bool correct = queue.TryDequeue(d);
	  if(correct) {
	    rapidjson::Value v(rapidjson::kObjectType);
	    for(rapidjson::Document::MemberIterator it = d->MemberBegin(); it != d->MemberEnd(); ++it) {
	      v.AddMember(it->name, it->value, allocator);
	    }
	    l.push_back(d);
	    events.PushBack(v, allocator);
	  }
	}
	
	rapidjson::StringBuffer buffer;
	rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);
	events.Accept(writer);

	if(size > 0 && checkPortTCP(3000, "conciens.mooo.com")) {
	  RestClient::response r = RestClient::post("http://conciens.mooo.com:3000/event", "text/json", buffer.GetString());
	  actions.Parse(r.body.c_str());
	  processActions(actions);
	}

	while(!l.empty()) {
	  d = l.front();
	  l.pop_front();
	  delete d;
	}
		
	sleep(1);
	pthread_create(&thread1, NULL, processMessages, NULL);
	
	//if (strcmp(recv_data, "q") == 0 || strcmp(recv_data, "Q") == 0)
	//{
	//	close(sock);
	//	break;
	//}

	//else
	//	printf("\nRecieved data = %s ", recv_data);

	//printf("\nSEND (q or Q to quit) : ");
	//gets(send_data);
}

EventBridge::EventBridge()
{
	pthread_t	thread1;
	int		iret;

	TC_LOG_INFO("server.loading", "EventBridge: Starting EventBridge...");

	/* Create independent threads each of which will execute function */
	iret = pthread_create(&thread1, NULL, processMessages, NULL);

	/* Wait till threads are complete before main continues. Unless we  */
	/* wait we run the risk of executing an exit which will terminate   */
	/* the process and all threads before the threads have completed.   */
	//pthread_join( thread1, NULL);
}

EventBridge::~EventBridge()
{
	// TODO Auto-generated destructor stub
}

void EventBridge::sendEvent(const int event_type, const Player* player, const Creature* creature, const uint32 num,
			    const Item* item, const Quest* quest, const SpellCastTargets* targets,
			    const ItemTemplate* proto, const uint32 num2, const char* st, const GameObject* go,
			    const AreaTriggerEntry* area, const Weather* weather, const int state,
			    const float grade, const Unit* target, const AuctionHouseObject* ah,
			    const AuctionEntry* entry, const Group* group, const Guild* guild,
			    const Channel* channel, const Spell* spell, const Unit* actor)
{
	float	x, y, z, o;

	rapidjson::Document* d = new rapidjson::Document();
	rapidjson::Value jsonNums(rapidjson::kArrayType);
	rapidjson::Value jsonPlayer(rapidjson::kObjectType);
	rapidjson::Value jsonActor(rapidjson::kObjectType);
	rapidjson::Value jsonCreature (rapidjson::kObjectType);
	rapidjson::Value jsonItem (rapidjson::kObjectType);
	rapidjson::Value jsonQuest (rapidjson::kObjectType);
	rapidjson::Value jsonTarget (rapidjson::kObjectType);
	rapidjson::Value jsonItemTemplate (rapidjson::kObjectType);
	rapidjson::Value jsonGameObject (rapidjson::kObjectType);
	rapidjson::Value jsonWeather (rapidjson::kObjectType);
	rapidjson::Value jsonAuctionHouseObject (rapidjson::kObjectType);
	rapidjson::Value jsonAuctionEntry (rapidjson::kObjectType);
	rapidjson::Value jsonGroup (rapidjson::kObjectType);
	rapidjson::Value jsonGuild (rapidjson::kObjectType);
	rapidjson::Value jsonChannel (rapidjson::kObjectType);
	rapidjson::Value jsonSpell (rapidjson::kObjectType);
	rapidjson::Document::AllocatorType& a = d->GetAllocator();
	d->SetObject();
	
	d->AddMember("event-type", idToEventType[event_type], a);
	
	jsonNums.PushBack(num, a).PushBack(num2, a);
	d->AddMember("num-values", jsonNums, a);
	
	if(st != NULL) {
	  TC_LOG_INFO("server.loading", st);
	  rapidjson::Value s;
	  s.SetString(st, strlen(st), a);
	  d->AddMember("string-value", s, a);
	}
	
	if(area != NULL) {
	  d->AddMember("area", area->id, a);
	}
	
	if(player != NULL) {
	  player->GetPosition(x, y, z, o);
	  jsonPlayer.AddMember("guid", player->GetGUIDLow(), a);
	  jsonPlayer.AddMember("name", player->GetName().c_str(), a);
	  jsonPlayer.AddMember("level", player->getLevel(), a);
	  rapidjson::Value s;
	  const char* text = player->ToString().c_str();
	  s.SetString(text, strlen(text), a);
	  jsonPlayer.AddMember("description", s, a);
	  jsonPlayer.AddMember("x", x, a);
	  jsonPlayer.AddMember("y", y, a);
	  jsonPlayer.AddMember("z", z, a);
	  jsonPlayer.AddMember("o", o, a);
	  d->AddMember("player", jsonPlayer, a);
	  
	  Player *p = sObjectAccessor->FindPlayer(player->GetGUIDLow());
	  sWorld->SendServerMessage(SERVER_MSG_STRING, "hello player", p);
	}
	
	if(actor != NULL) {
	  actor->GetPosition(x, y, z, o);
	  jsonActor.AddMember("guid", actor->GetGUIDLow(), a);
	  jsonActor.AddMember("name", actor->GetName().c_str(), a);
	  jsonActor.AddMember("level", actor->getLevel(), a);
	  rapidjson::Value s;
	  const char* text = actor->ToString().c_str();
	  s.SetString(text, strlen(text), a);
	  jsonActor.AddMember("description", s, a);
	  jsonActor.AddMember("x", x, a);
	  jsonActor.AddMember("y", y, a);
	  jsonActor.AddMember("z", z, a);
	  jsonActor.AddMember("o", o, a);
	  d->AddMember("actor", jsonActor, a);
	}
	
	if(target != NULL) {
	  jsonTarget.AddMember("guid", target->GetGUIDLow(), a);
	  jsonTarget.AddMember("name", target->GetName().c_str(), a);
	  jsonTarget.AddMember("level", target->getLevel(), a);
	  jsonTarget.AddMember("x", x, a);
	  jsonTarget.AddMember("y", y, a);
	  jsonTarget.AddMember("z", z, a);
	  jsonTarget.AddMember("o", o, a);
	  d->AddMember("target", jsonTarget, a);
	}
	
	if(creature != NULL) {
	  jsonCreature.AddMember("guid", creature->GetGUIDLow(), a);
	  jsonCreature.AddMember("name", creature->GetName().c_str(), a);
	  jsonCreature.AddMember("level", creature->getLevel(), a);
	  jsonCreature.AddMember("x", x, a);
	  jsonCreature.AddMember("y", y, a);
	  jsonCreature.AddMember("z", z, a);
	  jsonCreature.AddMember("o", o, a);
	  d->AddMember("creature", jsonCreature, a);
	}
	
	if(item != NULL) {
	  jsonItem.AddMember("guid", item->GetGUIDLow(), a);
	  jsonItem.AddMember("name", item->GetTemplate()->Name1.c_str(), a);
	  d->AddMember("item", jsonItem, a);
	}
	
	if(quest != NULL) {
	  jsonQuest.AddMember("id", quest->GetQuestId(), a);
	  jsonQuest.AddMember("name", quest->GetTitle().c_str(), a);
	  jsonQuest.AddMember("description", quest->GetDetails().c_str(), a);
	  d->AddMember("quest", jsonQuest, a);
	}

	if(targets != NULL) {
	  jsonTarget.AddMember("guid", targets->GetUnitTarget()->GetGUIDLow(), a);
	  jsonTarget.AddMember("name", targets->GetUnitTarget()->GetName().c_str(), a);
	  jsonTarget.AddMember("level", targets->GetUnitTarget()->getLevel(), a);
	  d->AddMember("target", jsonTarget, a);
	}

	if(proto != NULL) {
	  jsonItemTemplate.AddMember("id", proto->ItemId, a);
	  jsonItemTemplate.AddMember("name", proto->Name1.c_str(), a);
	  d->AddMember("item-template", jsonItemTemplate, a);
	}

	if(go != NULL) {
	  jsonGameObject.AddMember("guid", go->GetGUIDLow(), a);
	  jsonGameObject.AddMember("name", go->GetName().c_str(), a);
	  d->AddMember("game-object", jsonGameObject, a);
	}
	 
	if(weather != NULL) {
	  jsonWeather.AddMember("zone", weather->GetZone(), a);
	  jsonWeather.AddMember("state", state, a);
	  jsonWeather.AddMember("grade", grade, a);
	  d->AddMember("weather", jsonWeather, a);
	}
	
	if(ah != NULL) {
	  jsonAuctionHouseObject.AddMember("count", ah->Getcount(), a);
	  d->AddMember("auction-house-object", jsonAuctionHouseObject, a);
	}
	
	if(entry != NULL) {
	  jsonAuctionEntry.AddMember("id", entry->itemGUIDLow, a);
	  jsonAuctionEntry.AddMember("bid", entry->bid, a);
	  jsonAuctionEntry.AddMember("bidder", entry->bidder, a);
	  d->AddMember("auction-house-object", jsonAuctionHouseObject, a);
	}
	
	if(group != NULL) {
	  jsonGroup.AddMember("guid", group->GetLowGUID(), a);
	  jsonGroup.AddMember("leader-guid", group->GetLeaderGUID(), a);
	  jsonGroup.AddMember("leader-name", group->GetLeaderName(), a);
	  rapidjson::Value jsonGroupMemberList(rapidjson::kArrayType);
	  
	  const Group::MemberSlotList& msl = group->GetMemberSlots();
	  for(std::list<Group::MemberSlot>::const_iterator it = msl.cbegin(); it != msl.cend(); it++) {
	    rapidjson::Value jsonGroupMember(rapidjson::kObjectType);
	    jsonGroupMember.AddMember("guid", it->guid, a);
	    jsonGroupMember.AddMember("name", it->name.c_str(), a);
	    jsonGroupMemberList.PushBack(jsonGroupMember, a);
	  }
	  
	  jsonGroup.AddMember("member-list", jsonGroupMemberList, a);
	  d->AddMember("group", jsonGroup, a);
	}
	
	if(guild != NULL) {
	  jsonGuild.AddMember("id", guild->GetId(), a);
	  jsonGuild.AddMember("name", guild->GetName().c_str(), a);
	  d->AddMember("guild", jsonGuild, a);
	}
	
	if(channel != NULL) {
	  jsonChannel.AddMember("id", channel->GetChannelId(), a);
	  jsonChannel.AddMember("name", channel->GetName().c_str(), a);
	  d->AddMember("channel", jsonChannel, a);
	}
	
	if(spell != NULL) {
	  jsonSpell.AddMember("id", spell->GetSpellInfo()->Id, a);
	  jsonSpell.AddMember("name", spell->GetSpellInfo()->SpellName, a);
	  jsonSpell.AddMember("family", spell->GetSpellInfo()->SpellFamilyName, a);
	  d->AddMember("spell", jsonSpell, a);
	}
	
	queue.Enqueue(d);
}
