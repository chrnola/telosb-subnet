#include <Timer.h>
#include "new.h"

configuration NodeAppC {
}

implementation {
	components NodeC as App;
	components MainC;
	components LedsC;
	components new TimerMilliC() as Timer0;
	components LocalTimeMilliC;
	components ActiveMessageC as AM;
	components new AMSenderC(AM_NODEMSG) as AMS;
	components new AMSenderC(AM_REPORTMSG) as AMSRep;
	components new AMReceiverC(AM_NODEMSG) as AMR;
	components new AMReceiverC(AM_TARGETMSG) as AMRTarg;
	components new AMReceiverC(AM_BEACONMSG) as AMRBeac;
	
	components CC2420ActiveMessageC;
	App -> CC2420ActiveMessageC.CC2420Packet;
	
	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	App.LocalTime -> LocalTimeMilliC;
	App.Packet -> AM;
	App.AMPacket -> AMS;
	App.AMSend -> AMS;
	App.AMSendReport -> AMSRep;
	App.AMControl -> AM;
	App.Receive -> AMR;
	App.ReceiveTarget -> AMRTarg;
	App.ReceiveBeacon -> AMRBeac;
}
