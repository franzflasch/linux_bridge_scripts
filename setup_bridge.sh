#!/bin/bash

set -e

BRIDGE="empty"
INTERFACES=()
SHOW="false"
REMOVE="false"
ADD="false"
IPADDR="false"
ADDBRIDGE="false"
DELBRIDGE="false"
DELINTERFACES="false"
BRINGUP="false"
BRINGDOWN="false"

function usage()
{
    echo "Add helptext here"
}

function get_attached_interfaces()
{
    local curr_attached_interfaces=$(brctl show ${BRIDGE} | awk 'FNR > 1 {print ";"$1";"$4} ORS="" ')
    curr_interfaces=($(echo ${curr_attached_interfaces} | sed "s/;/ /g"))
    curr_interfaces=(${curr_interfaces[@]:1})
    echo "${curr_interfaces[@]}"
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit 1
            ;;
        -b | --bridge)
            BRIDGE=${VALUE}
            ;;
        -i | --interface)
            INTERFACES+=(${VALUE})
            ;;
        -r | --remove)
            REMOVE="true"
            ;;
        -a | --add)
            ADD="true"
            ;;
        -s | --show)
            SHOW="true"
            ;;
        -p | --ipaddr)
            IPADDR=${VALUE}
            ;;
        -u | --bringup)
            BRINGUP="true"
            ;;
        -d | --bringdown)
            BRINGDOWN="true"
            ;;
        --addbridge)
            ADDBRIDGE="true"
            ;;
        --delbridge)
            DELBRIDGE="true"
            ;;
        --delall)
            DELINTERFACES="true"
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 2
            ;;
    esac
    shift
done

if [ "${BRIDGE}" = "empty" ]; then
    echo "No bridge name specified!"
    exit 3
fi

brctl show ${BRIDGE} > /dev/null 2>&1 && exit_code=$? || exit_code=$?
if [ "${ADDBRIDGE}" = "true" ]; then
    if [ ${exit_code} != 0 ]; then
        echo "${BRIDGE} does not exist"
        echo "creating new bridge ${BRIDGE}"
        brctl addbr ${BRIDGE}
    else
        echo "Bridge ${BRIDGE} already existing!"
        exit 4
    fi
fi

echo "Using Bridge: ${BRIDGE}"

if [ "${DELBRIDGE}" = "true" ]; then
    echo "removing bridge ${BRIDGE}"
    ip link set dev ${BRIDGE} down
    brctl delbr ${BRIDGE}
    exit 0
fi

if [ "${SHOW}" = "true" ]; then
    curr_interfaces=( $(get_attached_interfaces) )
    echo "attached interfaces on ${BRIDGE}:"
    for i in "${curr_interfaces[@]}"
    do
        echo "${i}"
    done
    exit 0
fi

if [ "${DELINTERFACES}" = "true" ]; then
    curr_interfaces=( $(get_attached_interfaces) )
    for i in "${curr_interfaces[@]}"
    do
        echo "removing interface ${i} from bridge"
        brctl delif ${BRIDGE} ${i}
    done
    exit 0
fi

if [ "${REMOVE}" = "true" ]; then
    for i in "${INTERFACES[@]}"
    do
        echo "removing interface ${i} from bridge"
        brctl delif ${BRIDGE} ${i}
    done
    exit 0
fi

if [ "${ADD}" = "true" ]; then
    for i in "${INTERFACES[@]}"
    do
        echo "adding interface: ${i}"
        brctl addif ${BRIDGE} ${i}
    done
fi

if [ "${IPADDR}" != "false" ]; then
    echo "Setting IP ${IPADDR} on ${BRIDGE}"
    ip addr flush dev ${BRIDGE}
    ip addr add ${IPADDR} dev ${BRIDGE}
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "Error setting ip address ${IPADDR}"
    fi
    exit 0
fi

if [ "${BRINGDOWN}" = "true" ]; then
    curr_interfaces=( $(get_attached_interfaces) )
    for i in "${curr_interfaces[@]}"
    do
        echo "bringing interface ${i} down"
        ip link set dev ${i} down
    done
    echo "bringing bridge ${i} down"
    ip link set dev ${BRIDGE} down
fi

if [ "${BRINGUP}" = "true" ]; then
    curr_interfaces=( $(get_attached_interfaces) )
    for i in "${curr_interfaces[@]}"
    do
        echo "bringing interface ${i} up"
        ip link set dev ${i} up
    done
    echo "bringing bridge ${i} up"
    ip link set dev ${BRIDGE} up
fi
