#ifndef NODE_H
#define NODE_H

typedef nx_struct NodeMsg {
	nx_uint16_t nodeid;
	nx_uint16_t rssi;
} NodeMsg;

typedef nx_struct BeaconMsg {
	nx_uint32_t clock;
	nx_uint16_t subnet;
} BeaconMsg;

typedef nx_struct TargetMsg {
	nx_uint16_t nodeid;
} TargetMsg;

typedef nx_struct ReportMsg {
	nx_uint16_t nodeid;
	nx_uint32_t timestamp;
} ReportMsg;

enum {
  AM_NODEMSG = 6,
  AM_REPORTMSG = 30,
  AM_TARGETMSG = 40,
  AM_BEACONMSG = 50,
  BEACON_PERIOD = 256,
  TARGET_PERIOD = 512,
  DEFAULT_FREQ_CHANNEL = 26,
  TOS_BCAST_ADDR = 100,
  SUBNET_ID = 16,
  NEAR_TIE_BREAK = 61
};

#endif