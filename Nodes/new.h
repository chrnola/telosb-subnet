#ifndef NODE_H
#define NODE_H

typedef nx_struct NodeMsg {
	nx_uint16_t nodeid;
} NodeMsg;

enum {
  AM_NODEMSG = 6,
  BEACON_PERIOD = 256,
  TARGET_PERIOD = 512,
  DEFAULT_FREQ_CHANNEL = 26,
  TOS_BCAST_ADDR = 100,
  SUBNET_ID = 16,
  NEAR_TIE_BREAK = 61
};

#endif