#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#
#Script Purpose
# - define a group of common functions to be called else where
###########################################################################################

#https://stackoverflow.com/questions/10822790/can-i-call-a-function-of-a-shell-script-from-another-shell-script/10823213
function createVnet(){
resoruceGroup=$1
vnetName=$2
vnetPrefix=$3
location=$4
nowait=$4

echo " creating vnet name: $vnetName prefix: $VnetPrefix " 

# az network vnet create -g $resoruceGroup -n $vnetName --address-prefix $vnetPrefix --no-wait
# if [[ $nowait -eq 1 ]]
# then

#     echo " creating vnet name: $vnetName prefix: $VnetPrefix default " 
#     az network vnet create -g $resoruceGroup -n $vnetName --address-prefix $vnetPrefix --no-wait
# else
#     echo " creating vnet name: $vnetName prefix: $VnetPrefix no wait mode " 
#     az network vnet create -g $resoruceGroup -n $vnetName --address-prefix $vnetPrefix 
# fi

}


function createSubnet(){

resoruceGroup=$1
subnetName=$2
vnetName=$3
addressPrefix=$4
location=$4
    az network vnet subnet create -g $resoruceGroup \
     --vnet-name $vnetName
     --name $subnetName \
    --address-prefixes $addressPrefix 
    --network-security-group MyNsg 
    --route-table MyRouteTable
}

function createSubnetWithAssociatedNsg(){
    
resoruceGroup=$1
subnetName=$2
vnetName=$3
addressPrefix=$4
nsg=$5
location=$4
    az network vnet subnet create -g $resoruceGroup \
     --vnet-name $vnetName
     --name $subnetName \
    --address-prefixes $addressPrefix 
    --network-security-group $nsg 
    --route-table MyRouteTable
}