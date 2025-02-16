#average throughput
BEGIN {
	recv_size=0
	sTime=1e6
	spTime=0
	NumOfRecd=0
	unit="kbps"
}
#This awk file works only for new trace format, old trace does not have support
{
event =$1
time=$3
node_id=$5
packet=$19
pkt_id=$41
flow_id=$39
packet_size=$37
flow_type=$45

if(packet=="AGT" && sendTime[pkt_id] == 0 && (event == "+" || event == "s")) {
	if (time < sTime) {
		sTime=time
	}
	sendTime[pkt_id] = time
	this_flow=flow_type
}

if(packet=="AGT" && event == "r") {
	if(time >spTime) {
		spTime=time
	}
	recv_size = recv_size + packet_size
	recvTime[pkt_id] = time
	NumOfRecd = NumOfRecd + 1
}
}

END {
	if (NumOfRecd ==0) {
		printf("No packets, the simulation might be very small \n")
	}
	printf("\n\n");
	printf("Start Time %d\n", sTime)
	printf("Stop Time %d\n", spTime)
	printf("Packets Received %d\n", NumOfRecd)
	printf("========================\n")
	printf("Throughput: %.2f %s\n", (NumOfRecd/(spTime-sTime)*(8/1000)),unit)
	printf("\n\n");
}
