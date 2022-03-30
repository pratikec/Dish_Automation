#!/bin/bash  

velocityUri=https://vel-demo-sb.spirenteng.com  

agentJson=`curl -k -s -X GET $velocityUri/ito/executions/v1/agents | jq -c '.[] | {status}' | jq -s "map({Status: .status}) | group_by(.Status) | map({(.[0].Status) : length})"`

echo $agentJson | jq '. | length'

if [ `echo $agentJson | jq '. | length'` -eq 0 ]
then
  echo Error collecting agent usage
else
  echo Sending agent usage to logstash
  curl -XPOST -d "$agentJson" http://localhost:8080
fi
