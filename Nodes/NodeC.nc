#include <Timer.h>
#include "new.h"

module NodeC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Receive;
}

implementation {
	bool busy = FALSE;
	message_t pkt;
	char timeout = 0;
	
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
  
  	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    	if (len == sizeof(NodeMsg)) {
      		NodeMsg* ndpkt = (NodeMsg*)payload;
      		if(ndpkt->nodeid) {
      			call Leds.led1On();
      		}
    	}
  		return msg;
  	}
}
