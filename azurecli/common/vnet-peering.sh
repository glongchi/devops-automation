
#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#
#Script Purpose
# - define a group of common functions to be called else where
###########################################################################################

function createVnetPeering(){
resoruceGroup=$1
name=$2  # example naming convention MyVnet1ToMyVnet2
vnetName=$3 # vnetname
remoteVnetName=$4 #Resource ID or name of the remote VNet.
location=$5
nowait=$6

az network vnet peering create -g $resoruceGroup \ 
-n $name --vnet-name $vnetName \
    --remote-vnet $remoteVnetName --allow-vnet-access  \
   --allow-forwarded-traffic  --allow-gateway-transit --use-remote-gateways
} 


function updateVnetPeeringAccessList(){

allowVnetAccess=$1
allowForwardedTraffic=$2
allowVnetAccess=$3
allowGatewayTransit=$4
# --use-remote-gateways
# Allows VNet to use the remote VNet's gateway. Remote VNet gateway must have --allow-gateway-transit enabled for remote peering.
# Only 1 peering can have this flag enabled. Cannot be set if the VNet already has a gateway.
useRemoteGateway=$5 #
}


function updateVnetPeeringAllowGatewayTransit()){
     resoruceGroup=$1
    name=$2  # example naming convention MyVnet1ToMyVnet2
    vnetName=$3 # vnetname

az network vnet peering update -g $resoruceGroup -n $name --vnet-name $vnetName --set allowGatewayTransit=true
}

function updateVnetPeeringUseRemoteGateways()){

    resoruceGroup=$1
    name=$2  # example naming convention MyVnet1ToMyVnet2
    vnetName=$3 # vnetname

    az network vnet peering update -g $resoruceGroup -n $name --vnet-name $vnetName --set useRemoteGateways=true
}