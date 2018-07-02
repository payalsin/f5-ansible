#!/bin/bash

VE_NAME='TestingOVFTool'
VE_SRC_FILE='/root/BIGIP-13.1.0.5-0.0.5.ALL-NEW-scsi.ova'
VCENTER_IP='10.192.73.xxx'
VCENTER_DC='F5 BD Lab'
VCENTER_CLUSTER='10.192.73.xx'
VCENTER_USER='administrator@vsphere.local'
VCENTER_PASS='xxxxx'
#Static IP to assign
BIGIP_MGMT='10.192.73.206/24'
BIGIP_MGMT_GW='10.192.73.1'
#Root and Admin password 
BIGIP_ROOT_PASS='default123'
BIGIP_ADMIN_PASS='admin123'
BIGIP_VE_NET_MGMT='Management=Cisco-BD73-MGMT'
BIGIP_VE_NET_EXT='External=BlackHole'
BIGIP_VE_NET_INT='Internal=BlackHole'
BIGIP_VE_NET_HA='HA=BlackHole'

ovftool \
--sourceType=OVA \
--acceptAllEulas \
--noSSLVerify \
--skipManifestCheck \
--X:logToConsole \
--datastore='datastore1 (2)' \
--net:$BIGIP_VE_NET_INT \
--net:$BIGIP_VE_NET_EXT \
--net:$BIGIP_VE_NET_HA \
--net:$BIGIP_VE_NET_MGMT \
--X:injectOvfEnv \
--prop:net.mgmt.addr=$BIGIP_MGMT \
--prop:net.mgmt.gw=$BIGIP_MGMT_GW \
--prop:user.root.pwd=$BIGIP_ROOT_PASS \
--prop:user.admin.pwd=$BIGIP_ADMIN_PASS \
--deploymentOption='dualcpu' \
--name=$VE_NAME \
$VE_SRC_FILE \
"vi://$VCENTER_USER:$VCENTER_PASS@$VCENTER_IP/$VCENTER_DC/host/$VCENTER_CLUSTER
