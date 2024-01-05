#! /bin/bash

COMMAND=./taterbot.py
LOGFILE=./runner_log.txt


echo 'Starting Application' >> $LOGFILE

while true ; do
	$COMMAND &
	CHILDPID=$!
	echo "Application Started with PID $CHILDPID" >> $LOGFILE

	while true ; do
		PCOUNT=`ps auxwww | awk '{print $2}'| grep '^'$CHILDPID'$' | wc -l`

		if [ $PCOUNT -eq 0 ]; then
			echo 'Application terminated...restarting...' >> $LOGFILE
			break;
		fi

		sleep 60
	done
done
