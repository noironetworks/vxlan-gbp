#!/bin/bash

ip link del vxlan0 2> /dev/null

ip link add vxlan0 type vxlan id 1 remote $1 gbp
ip addr add $2 dev vxlan0
ip link set vxlan0 up
ip -d link show vxlan0

/usr/share/openvswitch/scripts/ovs-ctl restart
ovs-vsctl del-br br0 2> /dev/null
ovs-vsctl add-br br0

ovs-vsctl add-port br0 int0 -- set Interface int0 type=internal
ip link set int0 up
ip addr add $3 dev int0

ovs-vsctl add-port br0 vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip=$1 options:exts=gbp
ovs-vsctl show

ovs-ofctl del-flows br0
ovs-ofctl add-flow br0 'in_port=1,priority=20,actions=load:0x200->NXM_NX_TUN_GBP_ID[],NORMAL'
ovs-ofctl add-flow br0 'priority=10,actions=NORMAL'
