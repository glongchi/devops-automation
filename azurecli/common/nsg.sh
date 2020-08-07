#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#
#Script Purpose
# - define a group of common functions to be called else where
###########################################################################################

function createNsg(){
resoruceGroup=$1
nsgName=$2
location=$3
nowait=$4

az network nsg create -g $resoruceGroup -n $nsgName --location $location

}


function addNsgRule(){
    
resoruceGroup=$1
nsgName=$2
ruleName=$3
priority=$3
sourceAdressPrefixes=$4 
sourcePortRanges=$5
destinationAdressPrefixes=$6 # example 80 8080
destinationPortRanges=$7
direction=$8 # Inbound, Outbound
access=$9 # 'Allow','Deny'
protocol=$10 #*, Ah, Esp, Icmp, Tcp, Udp
description=$11 # example : "Deny from specific IP address ranges on 80 and 8080."


az network nsg rule create --resource-group $resoruceGroup  \
     --name $nsgName
     --nsg-name $nsgName \
     --priority $priority \
     --source-address-prefixes $sourceAdressPrefixes \
     --source-port-ranges $sourcePortRanges \ 
     --destination-address-prefixes $destinationAdressPrefixes \
     --destination-port-ranges $destinationPortRanges \
     --direction $direction \ 
     --access $access \
     --protocol $protocol \ 
     --description $description

}


function addNsgRuleWithTags(){
resoruceGroup=$1
nsgName=$2
ruleName=$3
priority=$4
sourceAdressPrefixesByTags=$5 # tags: Internet VirtualNetwork
destinationAdressPrefixesByTag=$6 # storage
destinationPortRanges=$7
direction=$8
access=$9 # 'Allow','Deny'
protocol=$10 #*, Ah, Esp, Icmp, Tcp, Udp
description=$11 # example : "Deny from specific IP address ranges on 80 and 8080."


az network nsg rule create --resource-group $resoruceGroup  \
     --name $nsgName
     --nsg-name $nsgName \
     --priority $priority \
     --source-address-prefixes $sourceAdressPrefixesByTags \
     --destination-address-prefixes $destinationAdressPrefixesByTag \
     --destination-port-ranges $destinationPortRanges \
     --direction $direction \ 
     --access $access \
     --protocol $protocol \ 
     --description $description

}

function addNsgRuleWithAsg(){
    resoruceGroup=$1
    nsgName=$2
    ruleName=$3
    priority=$4
    sourceAdressPrefixesByTags=$5 # tags: Internet VirtualNetwork
    destinationApplicationSecurityGroup=$6 # web, app random user given name to represent a group of servers
    destinationPortRanges=$7
    direction=$8
    access=$9 # 'Allow','Deny'
    protocol=$10 #*, Ah, Esp, Icmp, Tcp, Udp
    description=$11 # example : "Deny from specific IP address ranges on 80 and 8080."


    az network nsg rule create --resource-group $resoruceGroup  \
        --name $nsgName
        --nsg-name $nsgName \
        --priority $priority \
        --source-address-prefixes $sourceAdressPrefixesByTags \
        --destination-asgs $destinationApplicationSecurityGroup \
        --destination-port-ranges $destinationPortRanges \
        --direction $direction \ 
        --access $access \
        --protocol $protocol \ 
        --description $description

}


function associateNsgWithSubnet(){

    resoruceGroup=$1
    vnetName=$2
    subnetName=$3
    nsgName=$4

    az network vnet subnet update --resource-group $resoruceGroup \
                                --vnet-name $vnetName \
                                --name $subnetName \
                                --network-security-group $nsgName
}

function associateNsgWithNic(){

}