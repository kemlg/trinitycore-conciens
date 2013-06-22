/*
 * EventBridge.cpp
 *
 *  Created on: 31 Jan 2011
 *      Author: sergio
 */

#include <pthread.h>
#include <stdlib.h>

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

const char*	endMsg		= "\n";
const int	port_out	= 6969;
const int	port_in		= 6970;
const char*	ebServerHost	= "192.168.1.101";
struct hostent*		host;
struct sockaddr_in	server_addr;

void* processMessages(void* ptr)
{
	int		bytes_received;
	char		recv_data[1024];
	int		sock, conn;
	pthread_t	thread1;

	sock = *(int*)ptr;
	bytes_received = recv(sock, recv_data, 1022, 0);
	while(bytes_received >= 0)
	{

		recv_data[bytes_received] = '\n';
		recv_data[bytes_received+1] = '\0';
		sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridgeThread [%s]", recv_data);
		bytes_received = recv(sock, recv_data, 1022, 0);
	}

	struct hostent*		host;
	struct sockaddr_in	server_addr;

	host = gethostbyname(ebServerHost);

	close(sock);
	sock = socket(AF_INET, SOCK_STREAM, 0);

	server_addr.sin_family = AF_INET;
	server_addr.sin_addr = *((struct in_addr *) host->h_addr);
	bzero(&(server_addr.sin_zero), 8);

	server_addr.sin_port = htons(port_in);
	conn = connect(sock, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));
	while(conn < 1)
	{
		sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: conn < 1, errno: %d", errno);
		close(sock);
		sock = socket(AF_INET, SOCK_STREAM, 0);
		conn = connect(sock, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));
	}
	sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: sockin >= 1");
	pthread_create(&thread1, NULL, processMessages, (void*)&sock);
	
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

void EventBridge::createSocketIn()
{
	struct hostent*		host;
	struct sockaddr_in	server_addr;

	host = gethostbyname(ebServerHost);

	this->sockin = socket(AF_INET, SOCK_STREAM, 0);

	server_addr.sin_family = AF_INET;
	server_addr.sin_addr = *((struct in_addr *) host->h_addr);
	bzero(&(server_addr.sin_zero), 8);

	server_addr.sin_port = htons(port_in);
	connect(sockin, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));
	if(sockin < 1)
	{
		sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: sockin < 1");
	}
	else
	{
		sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: sockin >= 1");
	}
}

void EventBridge::createSocketOut()
{
	connect(this->sockout, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));
	if(sockout < 1)
	{
		sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: sockout < 1");
	}
	else
	{
		sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: sockout >= 1");
	}
}

void EventBridge::createSocket()
{
	this->createSocketIn();
	this->createSocketOut();
}

EventBridge::EventBridge()
{
	pthread_t	thread1;
	int		iret;

	sLog->outInfo(LOG_FILTER_NETWORKIO, "EventBridge: Starting EventBridge...");
	host = gethostbyname(ebServerHost);

	this->sockout = socket(AF_INET, SOCK_STREAM, 0);

	server_addr.sin_family = AF_INET;
	server_addr.sin_addr = *((struct in_addr *) host->h_addr);
	bzero(&(server_addr.sin_zero), 8);

	server_addr.sin_port = htons(port_out);

	this->createSocket();

	/* Create independent threads each of which will execute function */
	iret = pthread_create(&thread1, NULL, processMessages, (void*)&this->sockin);

	/* Wait till threads are complete before main continues. Unless we  */
	/* wait we run the risk of executing an exit which will terminate   */
	/* the process and all threads before the threads have completed.   */
	//pthread_join( thread1, NULL);
}

EventBridge::~EventBridge()
{
	// TODO Auto-generated destructor stub
}

void EventBridge::sendMessage(char* send_data)
{
	int	ret;

	ret = send(sockout, send_data, strlen(send_data), 0);
	if(ret == -1)
	{
		sLog->outError(LOG_FILTER_NETWORKIO, "Regenerating socket\n");
		close(sockout);
		sockout = socket(AF_INET, SOCK_STREAM, 0);
		this->createSocketOut();
		ret = send(sockout, send_data, strlen(send_data), 0);
	}
	else
	{
		send(sockout, endMsg, strlen(endMsg), 0);
	
		if(strcmp(send_data, "q") == 0 || strcmp(send_data, "Q") == 0)
		{
			send(sockout, send_data, strlen(send_data), 0);
			close(sockout);
		}
	}
}

void EventBridge::sendEvent(const int event_type, const Player* player, const Creature* creature, const uint32 num,
	const Item* item, const Quest* quest, const SpellCastTargets* targets, const ItemTemplate *proto,
	const uint32 num2, const char* st, const GameObject* go, const AreaTriggerEntry* area,
	const Weather* weather, const int state, const float grade, const Player* other)
{
	char	msg[1024];
	bool	done;
	float	x, y, z, o;
	uint64	u1, u2;

	done = true;
	switch(event_type)
	{
	case EVENT_TYPE_PVP_KILL:
		sprintf(msg, "PVP_KILL|%llu|%llu", player->GetGUID(), other->GetGUID());
		break;
	case EVENT_TYPE_CREATURE_KILL:
		sprintf(msg, "CREATURE_KILL|%llu|%llu", player->GetGUID(), creature->GetGUID());
		break;
	case EVENT_TYPE_KILLED_BY_CREATURE:
		sprintf(msg, "KILLED_BY_CREATURE|%llu|%llu", player->GetGUID(), creature->GetGUID());
		break;
	case EVENT_TYPE_LEVEL_CHANGED:
		sprintf(msg, "LEVEL_CHANGED|%llu|%lu", player->GetGUID(), num);
		break;
	case EVENT_TYPE_MONEY_CHANGED:
		sprintf(msg, "MONEY_CHANGED|%llu|%lu", player->GetGUID(), num);
		break;
	case EVENT_TYPE_AREA_TRIGGER:
		sprintf(msg, "AREA_TRIGGER|%llu|%lu", player->GetGUID(), area->id);
		break;
	case EVENT_TYPE_WEATHER_CHANGE:
		sprintf(msg, "WEATHER_CHANGE|%lu|%d|%f", weather->GetZone(), state, grade);
		break;
	case EVENT_TYPE_WEATHER_UPDATE:
		sprintf(msg, "WEATHER_UPDATE|%lu|%lu", weather->GetZone(), num);
		break;
	case EVENT_TYPE_EMOTE:
		sprintf(msg, "EMOTE|%u|%llu", num, player->GetGUID());
		break;
	case EVENT_TYPE_GOSSIP_HELLO:
		sprintf(msg, "HELLO|%llu|%llu", player->GetGUID(), creature->GetGUID());
		break;
	case EVENT_TYPE_OBJECT_UPDATE:
		sprintf(msg, "OBJECT_UPDATE|%llu|%lu", go->GetGUID(), num);
		break;
	case EVENT_TYPE_CREATURE_UPDATE:
		creature->GetPosition(x, y, z, o);
		sprintf(msg, "CREATURE_UPDATE|%llu|%f|%f|%f|%f", creature->GetGUID(), x, y, z, o);
		break;
	case EVENT_TYPE_QUEST_ACCEPT:
		if(creature == NULL)
		{
			sprintf(msg, "QUEST_ACCEPT_ITEM|%llu|%llu|%lu", player->GetGUID(), item->GetGUID(), quest->GetQuestId());
		}
		else
		{
			sprintf(msg, "QUEST_ACCEPT_ITEM|%llu|%llu|%lu", player->GetGUID(), creature->GetGUID(), quest->GetQuestId());
		}
		break;
	case EVENT_TYPE_QUEST_ACCEPT_OBJECT:
		sprintf(msg, "QUEST_ACCEPT_OBJECT|%llu|%llu|%lu", player->GetGUID(), go->GetGUID(), quest->GetQuestId());
		break;
	case EVENT_TYPE_ITEM_USE: // TODO: Verify use of targets info
		sprintf(msg, "ITEM_USE|%llu|%llu|%llu", player->GetGUID(), item->GetGUID(), targets->GetUnitTarget()->GetGUID());
		break;
	case EVENT_TYPE_ITEM_EXPIRE:
		sprintf(msg, "ITEM_EXPIRE|%llu|%lu", player->GetGUID(), proto->ItemId);
		break;
	case EVENT_TYPE_GOSSIP_SELECT:
		sprintf(msg, "GOSSIP_SELECT|%llu|%llu|%lu|%lu", player->GetGUID(), creature->GetGUID(), num, num2);
		break;
	case EVENT_TYPE_GOSSIP_SELECT_OBJECT:
		sprintf(msg, "GOSSIP_SELECT_OBJECT|%llu|%llu|%lu|%lu", player->GetGUID(), go->GetGUID(), num, num2);
		break;
	case EVENT_TYPE_GOSSIP_SELECT_CODE:
		sprintf(msg, "GOSSIP_SELECT_CODE|%llu|%llu|%lu|%lu|%s", player->GetGUID(), creature->GetGUID(), num, num2, st);
		break;
	case EVENT_TYPE_GOSSIP_SELECT_CODE_OBJECT:
		sprintf(msg, "GOSSIP_SELECT_CODE_OBJECT|%llu|%llu|%lu|%lu|%s", player->GetGUID(), go->GetGUID(), num, num2, st);
		break;
	case EVENT_TYPE_QUEST_SELECT:
		sprintf(msg, "QUEST_SELECT|%llu|%llu|%lu", player->GetGUID(), creature->GetGUID(), quest->GetQuestId());
		break;
	case EVENT_TYPE_QUEST_COMPLETE:
		sprintf(msg, "QUEST_COMPLETE|%llu|%llu|%lu", player->GetGUID(), creature->GetGUID(), quest->GetQuestId());
		break;
	case EVENT_TYPE_QUEST_REWARD:
		sprintf(msg, "QUEST_REWARD|%llu|%llu|%lu|%lu", player->GetGUID(), creature->GetGUID(), quest->GetQuestId(), num);
		break;
	case EVENT_TYPE_QUEST_REWARD_OBJECT:
		sprintf(msg, "QUEST_REWARD_OBJECT|%llu|%llu|%lu|%lu", player->GetGUID(), go->GetGUID(), quest->GetQuestId(), num);
		break;
	case EVENT_TYPE_GET_DIALOG_STATUS:
		sprintf(msg, "GET_DIALOG_STATUS|%llu|%llu", player->GetGUID(), creature->GetGUID());
		break;
	case EVENT_TYPE_GET_DIALOG_STATUS_OBJECT:
		sprintf(msg, "GET_DIALOG_STATUS_OBJECT|%llu|%llu", player->GetGUID(), go->GetGUID());
		break;
	case EVENT_TYPE_OBJECT_CHANGED:
		sprintf(msg, "OBJECT_CHANGED|%llu|%lu", go->GetGUID(), num);
		break;
	default:
		sprintf(msg, "UNDEF|%d", event_type);
//		done = false;
	}

	if(done)
	{
		//sLog->outInfo(LOG_FILTER_NETWORKIO, "Sending: [%s]", msg);
		this->sendMessage(msg);
	}
}
