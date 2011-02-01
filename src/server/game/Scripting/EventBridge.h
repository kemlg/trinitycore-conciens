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

#include "Player.h"
#include "Creature.h"
#include "Item.h"

// Event Types
enum EventTypes
{
	EVENT_TYPE_EMOTE,
	EVENT_TYPE_QUEST_ACCEPT,
	EVENT_TYPE_ITEM_USE,
	EVENT_TYPE_ITEM_EXPIRE,
	EVENT_TYPE_GOSSIP_HELLO,
	EVENT_TYPE_GOSSIP_SELECT,
	EVENT_TYPE_GOSSIP_SELECT_CODE,
	EVENT_TYPE_GOSSIP_HELLO_OBJECT,
	EVENT_TYPE_GOSSIP_SELECT_OBJECT,
	EVENT_TYPE_GOSSIP_SELECT_CODE_OBJECT,
	EVENT_TYPE_QUEST_ACCEPT,
	EVENT_TYPE_QUEST_SELECT,
	EVENT_TYPE_QUEST_COMPLETE,
	EVENT_TYPE_QUEST_REWARD,
	EVENT_TYPE_GET_DIALOG_STATUS,
	EVENT_TYPE_QUEST_ACCEPT_OBJECT,
	EVENT_TYPE_QUEST_SELECT_OBJECT,
	EVENT_TYPE_QUEST_COMPLETE_OBJECT,
	EVENT_TYPE_QUEST_REWARD_OBJECT,
	EVENT_TYPE_GET_DIALOG_STATUS_OBJECT,
	EVENT_TYPE_OBJECT_DESTROYED,
	EVENT_TYPE_OBJECT_UPDATE,
	EVENT_TYPE_AREA_TRIGGER,
	EVENT_TYPE_WEATHER_CHANGE,
	EVENT_TYPE_WEATHER_UPDATE,
	EVENT_TYPE_PVP_KILL,
	EVENT_TYPE_CREATURE_KILL,
	EVENT_TYPE_KILLED_BY_CREATURE,
	EVENT_TYPE_MONEY_CHANGED,
	EVENT_TYPE_LEVEL_CHANGED,
	EVENT_TYPE_CREATURE_UPDATE,

	// counter
	NUM_EVENT_TYPES
};

class EventBridge
{
public:
	EventBridge();
	virtual ~EventBridge();
	void sendMessage(char*);
	void sendEvent(int,Player*,Creature*,uint32,Item*,Quest*,SpellCastTargets*,ItemPrototype*,uint32,char*,GameObject*,
			AreaTriggerEntry*,Weather*,WeatherState,float,Player*);

private:
	int					sockout, sockin;
};

#endif /* EVENTBRIDGE_H_ */
