#!/bin/bash
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with bash...) at the command prompt (uses shortened URL to this script as committed in GitHub repo):
#
#   bash <(curl -sL https://git.io/slathrop-az-hello-you)
#

# read -p "Enter your first name: " FNAME

# echo Hello $FNAME!
echo Your Azure Subscriptions are as follows...
#az account list

#https://stackoverflow.com/questions/10822790/can-i-call-a-function-of-a-shell-script-from-another-shell-script/10823213
source ../common/vnet.sh

 #echo '[{"vnetName": "vnethub", "vnetAddresSpace":"10.0.0.0/16"},{"vnetName": "vnet1", "vnetAddresSpace":"10.1.0.0/16"}]' | jq .[]

 #declare global variables;
resourceGroup101=az300networks101
resourceGroup102=az300networks102
location=eastus



az group create --name resourceGroup101 --location eastus

for record in $(cat "./network101.json" | | jq -c '.[]'); do
    vnetName=$(echo "${record}"  | jq '.vnetName')	
    VnetPrefix=$(echo "${record}"  | jq '.VnetPrefix')

   createVnet	$resourceGroup102 $vnetName  $VnetPrefix $location 
done
