VXLAN Group Policy Extension
============================

This tutorial walks through the steps required to get a VXLAN-GBP testbed up and
running to play with the technology.

= FastTrack: Vagrant

Running `vagrant up` will provision two Fedora 20 based VMs named `kernel1` and
`kernel2` with a VXLAN-GBP enabled kernel, iproute2, and Open vSwitch. Use
`vagrant ssh`  to log into the VMs.

This will give you the following topology:

    +------------------------------+     +------------------------------+
    | kernel1                      |     | kernel2                      |
    |                              |     |                              |
    |  30.1.1.10/24                |     |  30.1.1.20/24                |
    |      int0                    |     |      int0                    |
    |       |                      |     |       |                      |
    |      OVS                     |     |      OVS                     |
    |       |         10.1.1.10/24 |     |       |         10.1.1.20/24 |
    |     vxlan           vxlan0   |     |     vxlan           vxlan0   |
    |       +------+--------+      |     |       +-----+---------+      |
    |              |               |     |             |                |
    |        20.1.1.10/24          |     |        20.1.1.20/24          |
    |            enp0s8            |     |           enp0s8             |
    +--------------|---------------+     +-------------|----------------+
                   |                                   |
                   +--------[ Private Network ]--------+

= Manual Installation

== Dependencies

The following git branches hold the changes required to enable VXLAN-GBP in the
relevant components. These changes are being pushed upstream into the respective
usptream trees and will become available in vanilla distributions.

 * kernel: https://github.com/tgraf/net-next/tree/vxlan-gbp
 * OVS: https://github.com/tgraf/ovs/tree/vxlan-gbp
 * iproute2: https://github.com/tgraf/iproute2/tree/vxlan-gbp

== VXLAN-GBP Tunnel with iproute2

To create a VXLAN tunnel with iproute2 to the VTEP 20.1.1.20 with the GBP
extension enabled, run:

    ip link add vxlan0 type vxlan id 1 remote 20.1.1.20 gbp
    ip link set vxlan0 up

== VXLAN-GBP Tunnel with Open vSwitch

    ovs-vsctl add-port br0 vxlan0 -- \
    set Interface vxlan0 type=vxlan options:remote_ip=20.1.1.20 \
                                    options:exts=gbp

= Open vSwitch Examples

== Mapping a port to a Group ID

Assign all packets from port 10 to group 0x100 and proceed with normal packet
processing:

    ovs-ofctl add-flow br0 'in_port=10,actions=load:0x100->NXM_NX_TUN_GBP_ID[],NORMAL'

= iproute2 + iptables Examples

== Map UID to Group ID

    iptables -I OUTPUT -m owner --uid-owner 101 -j MARK --set-mark 0x200



