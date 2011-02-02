/*
 * EventBridge.cpp
 *
 *  Created on: 31 Jan 2011
 *      Author: sergio
 */

#include <pthread.h>
#include <stdlib.h>

#include "EventBridge.h"
#include "Log.h"
#include "GameObject.h"

const char*	endMsg		= "\n";
const int	port_out	= 6969;
const int	port_in		= 6970;

void* processMessages(void* ptr)
{
	int		bytes_recieved;
	char	recv_data[1024];
	int		sock;

	sock = *(int*)ptr;
	while(1)
	{
		bytes_recieved = recv(sock, recv_data, 1022, 0);
		recv_data[bytes_recieved] = '\n';
		recv_data[bytes_recieved+1] = '\0';

		sLog->outBasic("EventBridgeThread [%s]", recv_data);
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
}

EventBridge::EventBridge()
{
	struct hostent*		host;
	struct sockaddr_in	server_addr;
	pthread_t			thread1;
	int					iret;

	sLog->outBasic("EventBridge: Starting EventBridge...");
	host = gethostbyname("127.0.0.1");

	this->sockin = socket(AF_INET, SOCK_STREAM, 0);
	this->sockout = socket(AF_INET, SOCK_STREAM, 0);

	server_addr.sin_family = AF_INET;
	server_addr.sin_addr = *((struct in_addr *) host->h_addr);
	bzero(&(server_addr.sin_zero), 8);

	server_addr.sin_port = htons(port_in);
	connect(sockin, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));
	if(sockin < 1)
	{
		sLog->outBasic("EventBridge: sockin < 1");
	}
	else
	{
		sLog->outBasic("EventBridge: sockin >= 1");
	}

	server_addr.sin_port = htons(port_out);
	connect(sockout, (struct sockaddr *) &server_addr, sizeof(struct sockaddr));
	if(sockout < 1)
	{
		sLog->outBasic("EventBridge: sockout < 1");
	}
	else
	{
		sLog->outBasic("EventBridge: sockout >= 1");
	}

	/* Create independent threads each of which will execute function */
	iret = pthread_create(&thread1, NULL, processMessages, (void*)&sockin);

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
	send(sockout, send_data, strlen(send_data), 0);
	send(sockout, endMsg, strlen(endMsg), 0);

	if(strcmp(send_data, "q") == 0 || strcmp(send_data, "Q") == 0)
	{
		send(sockout, send_data, strlen(send_data), 0);
		close(sockout);
	}
}

void EventBridge::sendEvent(const int event_type, const Player* player, const Creature* creature, const uint32 num,
	const Item* item, const Quest* quest, const SpellCastTargets* targets, const ItemPrototype *proto,
	const uint32 num2, const char* st, const GameObject* go, const AreaTriggerEntry* area,
	const Weather* weather, const int state, const float grade, const Player* other)
{
	char	msg[1024];
	bool	done;

	done = true;
	switch(event_type)
	{
	case EVENT_TYPE_EMOTE:
		sprintf(msg, "EMOTE|%u|%llu", num, player->GetGUID());
		break;
	case EVENT_TYPE_GOSSIP_HELLO:
		sprintf(msg, "HELLO|%llu|%llu", player->GetGUID(), creature->GetGUID());
		break;
	case EVENT_TYPE_OBJECT_UPDATE:
		sprintf(msg, "OBJECT_UPDATE|%llu", go->GetGUID());
		break;
	case EVENT_TYPE_CREATURE_UPDATE:
		sprintf(msg, "CREATURE_UPDATE|%llu", creature->GetGUID());
	default:
		sprintf(msg, "UNDEF|%d", event_type);
//		done = false;
	}

	if(done)
	{
		sLog->outBasic("Sending: [%s]", msg);
		this->sendMessage(msg);
	}
}
