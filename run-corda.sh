#!/bin/sh

# If variable not present use default values
: ${CORDA_HOME:=/opt/corda}
: ${JAVA_OPTIONS:=-Dlog4j.configurationFile=/opt/corda/log4j.xml -Xmx2048m}

export CORDA_HOME JAVA_OPTIONS

cd ${CORDA_HOME}

echo "Start Corda in tmux session"
echo "Using JAVA_OPTIONS: ${JAVA_OPTIONS}"

tmux new -d -s corda java $JAVA_OPTIONS -jar ${CORDA_HOME}/corda.jar

echo "Waiting Corda to start up"
while [ ! -n "$(ls -A logs/node-*.log 2>/dev/null)" ]
do
  echo "."
  sleep 2
done

echo "Corda started and ready to tail logs"

tail -f logs/node-*.log