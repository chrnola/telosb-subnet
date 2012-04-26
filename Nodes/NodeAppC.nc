#include <Timer.h>
#include "new.h"

configuration NodeAppC {
}

implementation {
	components NodeC as App;
	components MainC;
	components LedsC;
	components new TimerMilliC() as Timer0;
	components ActiveMessageC as AM;
	components new AMSenderC(AM_NODEMSG) as AMS;
	components new AMReceiverC(AM_NODEMSG) as AMR;
	
	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	App.Packet -> AM;
	App.AMPacket -> AMS;
	App.AMSend -> AMS;
	App.AMControl -> AM;
	App.Receive -> AMR;
}
