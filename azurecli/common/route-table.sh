
#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#
#az network route-table create --name
                            #   --resource-group
                            #   [--disable-bgp-route-propagation {false, true}]
                            #   [--location]
                            #   [--subscription]
                            #   [--tags]
#Script Purpose
# - define a group of common functions to be called else where
############################################################################################

function createRouteTable(){
    resourceGroup=$1
    tableName=$2
    az network route-table create -g $resourceGroup \
    --name $tableName=$2
}


function createRouteTableRoute(){
    resourceGroup=$1
    tableName=$2
    routeName=$3
    netHopType=$4 #accepted values: Internet, None, VirtualAppliance, VirtualNetworkGateway, VnetLocal
    addressPrefix=$5 #The destination CIDR to which the route applies.

    az network route-table route create -g $resourceGroup --route-table-name $tableName -n $routeName \
    --next-hop-type $netHopType --address-prefix $addressPrefix 
}

function createRouteTableRouteWithVirtualAppliance(){
    resourceGroup=$1
    tableName=$2
    routeName=$3
    netHopType=$4
    addressPrefix=$5
    nextHopIpAddress=$6 #The IP address packets should be forwarded to when using the VirtualAppliance hop type.

    az network route-table route create -g $resourceGroup \
     --route-table-name $tableName \
     --name $routeName \
     --next-hop-type VirtualAppliance \
     --address-prefix $addressPrefix \
     --next-hop-ip-address $nextHopIpAddress
}