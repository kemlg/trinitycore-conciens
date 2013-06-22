/*
 * EventBridge.h
 *
 *  Created on: 31 Jan 2011
 *      Author: sergio
 */

#ifndef EVENTBRIDGE_H_
#define EVENTBRIDGE_H_

#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#include "Common.h"
#include <ace/Singleton.h>
#include <ace/Atomic_Op.h>

#include "DBCStores.h"
#include "SharedDefines.h"
#include "World.h"
#include "Weather.h"

class AuctionHouseObject;
class AuraScript;
class Battleground;
class BattlegroundMap;
class Channel;
class ChatCommand;
class Creature;
class CreatureAI;
class DynamicObject;
class GameObject;
class GameObjectAI;
class Guild;
class GridMap;
class Group;
class InstanceMap;
class InstanceScript;
class Item;
class ItemTemplate;
class Map;
class OutdoorPvP;
class Player;
class Quest;
class ScriptMgr;
class Spell;
class SpellScript;
class SpellCastTargets;
class Transport;
class Unit;
class Vehicle;
class WorldPacket;
class WorldSocket;
class WorldObject;

// Event Types
enum ConciensEventTypes
{
	EVENT_TYPE_EMOTE,							//  0
	EVENT_TYPE_ITEM_USE,						//  1
	EVENT_TYPE_ITEM_EXPIRE,						//  2
	EVENT_TYPE_GOSSIP_HELLO,					//  3
	EVENT_TYPE_GOSSIP_SELECT,					//  4
	EVENT_TYPE_GOSSIP_SELECT_CODE,				//  5
	EVENT_TYPE_GOSSIP_HELLO_OBJECT,				//  6
	EVENT_TYPE_GOSSIP_SELECT_OBJECT,			//  7
	EVENT_TYPE_GOSSIP_SELECT_CODE_OBJECT,		//  8
	EVENT_TYPE_QUEST_ACCEPT,					//  9
	EVENT_TYPE_QUEST_SELECT,					// 10
	EVENT_TYPE_QUEST_COMPLETE,					// 11
	EVENT_TYPE_QUEST_REWARD,					// 12
	EVENT_TYPE_GET_DIALOG_STATUS,				// 13
	EVENT_TYPE_QUEST_ACCEPT_OBJECT,				// 14
	EVENT_TYPE_QUEST_SELECT_OBJECT,				// 15
	EVENT_TYPE_QUEST_COMPLETE_OBJECT,			// 16
	EVENT_TYPE_QUEST_REWARD_OBJECT,				// 17
	EVENT_TYPE_GET_DIALOG_STATUS_OBJECT,		// 18
	EVENT_TYPE_OBJECT_CHANGED,				// 19
	EVENT_TYPE_OBJECT_UPDATE,					// 20
	EVENT_TYPE_AREA_TRIGGER,					// 21
	EVENT_TYPE_WEATHER_CHANGE,					// 22
	EVENT_TYPE_WEATHER_UPDATE,					// 23
	EVENT_TYPE_PVP_KILL,						// 24
	EVENT_TYPE_CREATURE_KILL,					// 25
	EVENT_TYPE_KILLED_BY_CREATURE,				// 26
	EVENT_TYPE_MONEY_CHANGED,					// 27
	EVENT_TYPE_LEVEL_CHANGED,					// 28
	EVENT_TYPE_CREATURE_UPDATE,					// 29
	EVENT_TYPE_PLAYER_UPDATE,					// 30

	// counter
	NUM_EVENT_TYPES
};

class EventBridge
{
public:
	EventBridge();
	virtual ~EventBridge();
	void sendMessage(char*);
	void sendEvent(const int event_type, const Player* player, const Creature* creature = NULL, const uint32 num = NULL,
		const Item* item = NULL, const Quest* quest = NULL, const SpellCastTargets* targets = NULL, const ItemTemplate *proto = NULL,
		const uint32 num2 = NULL, const char* st = NULL, const GameObject* go = NULL, const AreaTriggerEntry* area = NULL,
		const Weather* weather = NULL, const int state = NULL, const float grade = NULL, const Player* other = NULL);

private:
	int		sockout, sockin;
	void	createSocket();
	void	createSocketIn();
	void	createSocketOut();
};

#endif /* EVENTBRIDGE_H_ */
