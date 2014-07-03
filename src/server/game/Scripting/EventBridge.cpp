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
#include "WorldPacket.h"
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include "restclient.h"

const char* idToEventType[] = {"EVENT_TYPE_EMOTE", "EVENT_TYPE_ITEM_USE", "EVENT_TYPE_ITEM_EXPIRE",
  "EVENT_TYPE_GOSSIP_HELLO", "EVENT_TYPE_GOSSIP_SELECT", "EVENT_TYPE_GOSSIP_SELECT_CODE",
  "EVENT_TYPE_GOSSIP_HELLO_OBJECT", "EVENT_TYPE_GOSSIP_SELECT_OBJECT", "EVENT_TYPE_GOSSIP_SELECT_CODE_OBJECT",
  "EVENT_TYPE_QUEST_ACCEPT", "EVENT_TYPE_QUEST_SELECT", "EVENT_TYPE_QUEST_COMPLETE", "EVENT_TYPE_QUEST_REWARD",
  "EVENT_TYPE_GET_DIALOG_STATUS", "EVENT_TYPE_QUEST_ACCEPT_OBJECT", "EVENT_TYPE_QUEST_SELECT_OBJECT",
  "EVENT_TYPE_QUEST_COMPLETE_OBJECT", "EVENT_TYPE_QUEST_REWARD_OBJECT", "EVENT_TYPE_GET_DIALOG_STATUS_OBJECT",
  "EVENT_TYPE_OBJECT_CHANGED", "EVENT_TYPE_OBJECT_UPDATE", "EVENT_TYPE_AREA_TRIGGER", "EVENT_TYPE_WEATHER_CHANGE",
  "EVENT_TYPE_WEATHER_UPDATE", "EVENT_TYPE_PVP_KILL", "EVENT_TYPE_CREATURE_KILL", "EVENT_TYPE_KILLED_BY_CREATURE",
  "EVENT_TYPE_MONEY_CHANGED", "EVENT_TYPE_LEVEL_CHANGED", "EVENT_TYPE_CREATURE_UPDATE", "EVENT_TYPE_PLAYER_UPDATE"
};

const char*	endMsg		= "\n";
const int	port_out	= 6969;
const int	port_in		= 6970;
const char*	ebServerHost	= "conciens.mooo.com";
struct hostent*		host;
struct sockaddr_in	server_addr;

void processActions(rapidjson::Document& d) {
  // TODO: Do something with actions!
}

void* processMessages(void* ptr)
{
	// TC_LOG_INFO("server.loading", "Proactively getting actions...");

	pthread_t thread1;
	RestClient::response r = RestClient::get("http://conciens.mooo.com:3000/actions");
	rapidjson::Document actions;
	
	actions.Parse(r.body.c_str());
	processActions(actions);
	
	sleep(5);
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
	const Item* item, const Quest* quest, const SpellCastTargets* targets, const ItemTemplate *proto,
	const uint32 num2, const char* st, const GameObject* go, const AreaTriggerEntry* area,
	const Weather* weather, const int state, const float grade, const Player* other)
{
	float	x, y, z, o;

	rapidjson::Document d;
	rapidjson::Value jsonNums(rapidjson::kArrayType);
	rapidjson::Value jsonPlayer(rapidjson::kObjectType);
	rapidjson::Value jsonTargetPlayer (rapidjson::kObjectType);
	rapidjson::Value jsonCreature (rapidjson::kObjectType);
	rapidjson::Value jsonItem (rapidjson::kObjectType);
	rapidjson::Value jsonQuest (rapidjson::kObjectType);
	rapidjson::Value jsonTarget (rapidjson::kObjectType);
	rapidjson::Value jsonItemTemplate (rapidjson::kObjectType);
	rapidjson::Value jsonGameObject (rapidjson::kObjectType);
	rapidjson::Value jsonWeather (rapidjson::kObjectType);
	rapidjson::Document::AllocatorType& a = d.GetAllocator();
	d.SetObject();
	
	d.AddMember("event-type", idToEventType[event_type], a);
	
	jsonNums.PushBack(num, a).PushBack(num2, a);
	d.AddMember("num-values", jsonNums, a);
	
	if(st != NULL) {
	  d.AddMember("string-value", st, a);
	}
	
	if(area != NULL) {
	  d.AddMember("area", area->id, a);
	}
	
	if(player != NULL) {
	  player->GetPosition(x, y, z, o);
	  jsonPlayer.AddMember("guid", player->GetGUIDLow(), a);
	  jsonPlayer.AddMember("name", player->GetName().c_str(), a);
	  jsonPlayer.AddMember("level", player->getLevel(), a);
	  jsonPlayer.AddMember("description", player->ToString().c_str(), a);
	  jsonPlayer.AddMember("x", x, a);
	  jsonPlayer.AddMember("y", y, a);
	  jsonPlayer.AddMember("z", z, a);
	  jsonPlayer.AddMember("o", o, a);
	  d.AddMember("player", jsonPlayer, a);
	}
	
	if(other != NULL) {
	  jsonTargetPlayer.AddMember("guid", other->GetGUIDLow(), a);
	  jsonTargetPlayer.AddMember("name", other->GetName().c_str(), a);
	  jsonTargetPlayer.AddMember("level", other->getLevel(), a);
	  jsonTargetPlayer.AddMember("x", x, a);
	  jsonTargetPlayer.AddMember("y", y, a);
	  jsonTargetPlayer.AddMember("z", z, a);
	  jsonTargetPlayer.AddMember("o", o, a);
	  d.AddMember("target-player", jsonTargetPlayer, a);
	}
	
	if(creature != NULL) {
	  jsonCreature.AddMember("guid", creature->GetGUIDLow(), a);
	  jsonCreature.AddMember("name", creature->GetName().c_str(), a);
	  jsonCreature.AddMember("level", creature->getLevel(), a);
	  jsonCreature.AddMember("x", x, a);
	  jsonCreature.AddMember("y", y, a);
	  jsonCreature.AddMember("z", z, a);
	  jsonCreature.AddMember("o", o, a);
	  d.AddMember("creature", jsonCreature, a);
	}
	
	if(item != NULL) {
	  jsonItem.AddMember("guid", item->GetGUIDLow(), a);
	  jsonItem.AddMember("name", item->GetTemplate()->Name1.c_str(), a);
	  d.AddMember("item", jsonItem, a);
	}
	
	if(quest != NULL) {
	  jsonQuest.AddMember("id", quest->GetQuestId(), a);
	  jsonQuest.AddMember("name", quest->GetTitle().c_str(), a);
	  jsonQuest.AddMember("description", quest->GetDetails().c_str(), a);
	  d.AddMember("quest", jsonQuest, a);
	}

	if(targets != NULL) {
	  jsonTarget.AddMember("guid", targets->GetUnitTarget()->GetGUIDLow(), a);
	  jsonTarget.AddMember("name", targets->GetUnitTarget()->GetName().c_str(), a);
	  jsonTarget.AddMember("level", targets->GetUnitTarget()->getLevel(), a);
	  d.AddMember("target", jsonTarget, a);
	}

	if(proto != NULL) {
	  jsonItemTemplate.AddMember("id", proto->ItemId, a);
	  jsonItemTemplate.AddMember("name", proto->Name1.c_str(), a);
	  d.AddMember("item-template", jsonItemTemplate, a);
	}

	if(go != NULL) {
	  jsonGameObject.AddMember("guid", go->GetGUIDLow(), a);
	  jsonGameObject.AddMember("name", go->GetName().c_str(), a);
	  d.AddMember("game-object", jsonGameObject, a);
	}
	 
	if(weather != NULL) {
	  jsonWeather.AddMember("zone", weather->GetZone(), a);
	  jsonWeather.AddMember("state", state, a);
	  jsonWeather.AddMember("grade", grade, a);
	  d.AddMember("weather", jsonWeather, a);
	}  
	
	rapidjson::StringBuffer buffer;
	rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);
	d.Accept(writer);
	
	RestClient::response r = RestClient::post("http://conciens.mooo.com:3000/event", "text/json", buffer.GetString());
	rapidjson::Document actions;
	
	actions.Parse(r.body.c_str());
	processActions(actions);
}
