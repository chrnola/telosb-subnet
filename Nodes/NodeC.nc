#include <Timer.h>
#include "new.h"

module NodeC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface LocalTime<TMilli>;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface AMSend as AMSendReport;
	uses interface SplitControl as AMControl;
	uses interface Receive;
	uses interface Receive as ReceiveTarget;
	uses interface Receive as ReceiveBeacon;
	
	uses interface CC2420Packet;
}

implementation {
	bool busy = FALSE;
	bool rep_busy = FALSE;
	bool isNear = FALSE;
	uint16_t currRssi = 0;
	message_t pkt;
	message_t rep_pkt;
	uint8_t timeout = 0;
	
	uint16_t getRssi(message_t *msg);
	
	event void Boot.booted() {
		call Leds.led2Off();
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if(err != SUCCESS) {
  	  		call AMControl.start();
  		}
	}
	
	event void Timer0.fired() {
		timeout++;
		if(timeout >= 5) {
			timeout = 0;
			call Leds.led2Off();
		} else {
			call Timer0.startOneShot(BEACON_PERIOD);
		}
	}
	
	event void AMControl.stopDone(error_t err) {
  	}
  
  	event void AMSend.sendDone(message_t* msg, error_t error) {
  		if(&pkt == msg) {
  	  		busy = FALSE;
  		}
  	}
  	
  	event void AMSendReport.sendDone(message_t* msg, error_t error) {
  		if(&rep_pkt == msg) {
  			rep_busy = FALSE;
  		}
  	}
  
  	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    	if (len == sizeof(NodeMsg)) {
      		NodeMsg* ndpkt = (NodeMsg*)payload;
      		if(ndpkt->rssi > currRssi) {
      			call Leds.led0Off();
      			call Leds.led1On();
      			isNear = FALSE;
      		} else {
      			if(ndpkt->rssi == currRssi) {
      				if(TOS_NODE_ID == NEAR_TIE_BREAK) {
      					call Leds.led1Off();
      					call Leds.led0On();
      					if(!isNear) {
      						ReportMsg* rpkt = (ReportMsg*) (call Packet.getPayload(&rep_pkt, sizeof(ReportMsg)));
  							rpkt->nodeid = TOS_NODE_ID;
  							rpkt->timestamp = call LocalTime.get();
  							if(call AMSendReport.send(DEFAULT_FREQ_CHANNEL, &rep_pkt, sizeof(ReportMsg)) == SUCCESS) {
  								rep_busy = TRUE;
  							}
      						isNear = TRUE;
      					}
      				} else {
      					call Leds.led0Off();
      					call Leds.led1On();
      					isNear = FALSE;
      				}
      			} else {
      				call Leds.led1Off();
      				call Leds.led0On();
      				if(!isNear) {
      					ReportMsg* rpkt = (ReportMsg*) (call Packet.getPayload(&rep_pkt, sizeof(ReportMsg)));
  						rpkt->nodeid = TOS_NODE_ID;
  						rpkt->timestamp = call LocalTime.get();
  						if(call AMSendReport.send(DEFAULT_FREQ_CHANNEL, &rep_pkt, sizeof(ReportMsg)) == SUCCESS) {
  							rep_busy = TRUE;
  						}
      					isNear = TRUE;
      				}
      			}
      		}
    	}
  		return msg;
  	}
  	
  	event message_t* ReceiveTarget.receive(message_t* msg, void* payload, uint8_t len) {
  		if(len == sizeof(TargetMsg)) {
  			NodeMsg* ndpkt = (NodeMsg*) (call Packet.getPayload(&pkt, sizeof(NodeMsg)));
  			ndpkt->nodeid = TOS_NODE_ID;
  			currRssi = getRssi(msg);
  			ndpkt->rssi = currRssi;
  			if(call AMSend.send(SUBNET_ID, &pkt, sizeof(NodeMsg)) == SUCCESS) {
  	  			busy = TRUE;
			}
		}
		return msg;
  	}
  	
  	event message_t* ReceiveBeacon.receive(message_t* msg, void* payload, uint8_t len) {
  		if(len == sizeof(BeaconMsg)) {
  			BeaconMsg* bcmsg = (BeaconMsg*) payload;
  			if(bcmsg->subnet == SUBNET_ID) {
  				ReportMsg* rpkt = (ReportMsg*) (call Packet.getPayload(&rep_pkt, sizeof(ReportMsg)));
  				rpkt->nodeid = TOS_NODE_ID;
  				rpkt->timestamp = call LocalTime.get();
  				if(call AMSendReport.send(DEFAULT_FREQ_CHANNEL, &rep_pkt, sizeof(ReportMsg)) == SUCCESS) {
  					rep_busy = TRUE;
  				}
  			}
  			call Leds.led2On();
  			timeout = 0;
  			call Timer0.startOneShot(BEACON_PERIOD);
  		}
  		return msg;
  	}
  	
  	uint16_t getRssi(message_t *msg){
		return (uint16_t) call CC2420Packet.getRssi(msg);
	}
}
