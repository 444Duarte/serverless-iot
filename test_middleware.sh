#!/bin/bash

LOCAL_IP="127.0.0.1:8080"
IP_CLOUD="192.168.78.128"
PORT_CLOUD="8080" 
CONNECTION=true

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--address-cloud)
    IP_CLOUD="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--port-cloud)
    PORT_CLOUD="$2"
    shift # past argument
    shift # past value
    ;;
    --no-connection)
    CONNECTION=false
    shift # past argument
    ;;
    *)    # unknown option
    print >&2 "Usage: $0 [--no-connection] [-a|--address-cloud   address-cloud] [-p|--port-cloud port-cloud] "
    exit 1;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Local node info"
curl --silent "http://$LOCAL_IP/function/func_nodeinfo" -d "" | grep Hostname

if [ "$CONNECTION" = true ];
then
    echo "Cloud node info"
    curl --silent "http://$IP_CLOUD:$PORT_CLOUD/function/func_nodeinfo" -d "" | grep Hostname
fi

############
echo "Testing functions"

# echo on
#set -x 
set -v

curl --silent "http://$LOCAL_IP/function/proxy" -d '{"func":"func_light", "data":{"value": true}}'

curl --silent "http://$LOCAL_IP/function/proxy" -d '{"func":"func_heavy", "data":{"value": false}}'

curl --silent "http://$LOCAL_IP/function/proxy" -d '{"func":"func_super_heavy", "data":{"value": true}}'

curl --silent "http://$LOCAL_IP/function/proxy" -d '{"func":"func_obese_heavy", "data":{"value": false}}'

set +v
