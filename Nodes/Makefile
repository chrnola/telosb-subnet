COMPONENT=NodeAppC
CC2420_CHANNEL=16
CFlags = -DCC2420_DEF_RFPower=3
BUILD_EXTRA_DEPS=NodeMsg.class

NodeMsg.class: NodeMsg.java
	javac NodeMsg.java
	
NodeMsg.java:
	mig java -target=null -java-classname=NodeMsg new.h NodeMsg -o $@
include $(MAKERULES)
