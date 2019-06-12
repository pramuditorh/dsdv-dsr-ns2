#packet Delivery Ratio
BEGIN {
	sendPkt =0;
	recvPkt=0;
#	forwardPkt=0;
	droppedPkt=0;
	count=0;
	genPkt=-1
	percent="%"
	ms="ms"
}

{
	packet=$19
	event = $1

#	if(packet == "AGT" && event = "s" && genPkt < $5){
#		genPkt = $5;
#	}
	
	if(event =="s" && packet == "AGT") {
		sendPkt++;
	}

	if(event =="r" && packet == "AGT") {
		recvPkt++;
	}

	if(event=="d" && $45 =="tcp"){
		droppedPkt++;
	}

	#End to End Delay
	if(packet=="AGT" && event == "s") {
		start_time[$47] = $3;
	}
	else if (($45 == "tcp") && (event == "r")){
		end_time[$47] = $3;
	}
	else if ((event == "d") && ($45 == "tcp")){
		end_time[$47] = -1;
	}
}

END {	
	for(i=0; i<=$47; i++ ){
		if(end_time[i] > 0){
			delay[i] = end_time[i] - start_time[i];
			count++;
		}
		else{
			delay[i] = -1;
		}
	}

	for(i=0; i<=$47; i++){
		if(delay[i] > 0){
			n_to_n_delay=n_to_n_delay+delay[i];
		}
	}
	n_to_n_delay=n_to_n_delay/count;

	printf ("\n\n");
	printf ("Packets Sent:  %d \n", sendPkt);
	printf ("Packets Received: %d \n", recvPkt);
	#printf ("the forwarded packets are %d \n", forwardPkt);
	printf ("Packets Dropped: %d \n", droppedPkt);
	printf ("======================================= \n")
	printf ("Packet Delivery Ratio: %.3f%s \n", ((recvPkt/sendPkt)*100), percent);
	printf ("Packet Loss: %.3f%s \n", ((sendPkt-recvPkt)/sendPkt)*100, percent)
	printf ("End to End Delay: %.3f\n", n_to_n_delay);
	printf ("Average End to End Delay: %.3f%s", n_to_n_delay*1000, ms);
	printf ("\n\n\n");
}
