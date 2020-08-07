#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#
#Script Purpose
# - stop an azure vm (not deallocate)
###########################################################################################
#variables
resourceGroup101=az300networks101
resourceGroup102=az300networks102
adminUser=glongchi
adminPassword=Adminsupport@2020
location=eastus
vnetGatewayPublicIp='vnetHub'



#create vnets and subnets

#create vnethub
az network vnet create --name vnetHub --resource-group az300networks101 --address-prefix 10.0.0.0/16 --wait
az network vnet subnet create --address-prefix 10.0.1.0/24 --name vnetHub-subnet1 --resource-group az300networks101 --vnet-name vnetHub --no-wait
az network vnet subnet create --address-prefix 10.0.254.0/27 --name GatewaySubnet--resource-group az300networks101 --vnet-name vnetHub --no-wait


#create vnet1
az network vnet create --name vnet1 --resource-group az300networks101 --address-prefix 10.1.0.0/16 --wait
az network vnet subnet create --address-prefix 10.0.1.0/24 --name vnet1-subnet1 --resource-group az300networks101 --vnet-name vnet1 --no-wait
az network vnet subnet create --address-prefix 10.0.254.0/27 --name GatewaySubnet--resource-group az300networks101 --vnet-name vnet1 --no-wait

#create vnet2
az network vnet create --name vnet2 --resource-group az300networks101 --address-prefix 10.2.0.0/16 --wait
az network vnet subnet create --address-prefix 10.0.1.0/24 --name vnet2-subnet1 --resource-group az300networks101 --vnet-name vnet2 --no-wait
az network vnet subnet create --address-prefix 10.0.254.0/27 --name GatewaySubnet--resource-group az300networks101 --vnet-name vnet2 --no-wait





#create vnetOnprem
az network vnet create --name vnetOnprem --resource-group az300networks101 --address-prefix 10.128.0.0/16 --wait
az network vnet subnet create --address-prefix 10.128.1.0/24 --name vnetOnprem-subnet1 --resource-group az300networks101 --vnet-name vnetOnprem --no-wait
az network vnet subnet create --address-prefix 10.128.254.0/27 --name GatewaySubnet--resource-group az300networks101 --vnet-name vnetOnprem --no-wait



#create route table


#create application security groups
#asg:web
az network asg create -g az300networks101 -n web 
#asg:mgmt
az network asg create -g az300networks101 -n mgmt 

#create network security groups
#nsg1
az network nsg create -g az300networks101 -n nsg1 --location eastus
#nsg1 rules
az network nsg rule create --resource-group az300networks101  --name allow-mgmt-access   --nsg-name nsg1  --priority 100  \
      --destination-address-prefixes 10.0.1.0/24  --destination-port-ranges 22
     --direction Inbound  --access Allow  --protocol ssh 
     --description "allow ssh"

#nsg1 rules
az network nsg rule create --resource-group az300networks101  --name allow-mgmt-access  --nsg-name nsg1  --priority 100 
     --destination-asgs mgmt  --destination-port-ranges 22 3389 --direction Inbound  --access Allow  --protocol Tcp \
     --description "allow access to through http/https"

az network nsg rule create --resource-group az300networks101  --name allow-web   --nsg-name nsg1  --priority 120 \
     --destination-asgs Web  --destination-port-ranges 80 443  --direction Inbound  --access Allow  --protocol Tcp \
     --description "allow access to through http/https"


#associate nsg1 with subnet: vnet1-subnet1
az network vnet subnet update -g az300networks101 -n vnet1-subnet1 --vnet-name vnet1 --network-security-group nsg1
#associate nsg-hub with subnet: vnetHub-subnet1
az network vnet subnet update -g az300networks101 -n vnetHub-subnet1 --vnet-name vnetHub --network-security-group nsg-hub


#create vms
#vnethub 

#create vnetHub-subnet1-vm1
az vm create --resource-group az300networks101 --name vnetHub-subnet1-vm1 --image UbuntuLTS --vnet-name vnetHub --subnet vnetHub-subnet1 \
--admin-username glongchi --admin-password Adminsupport@2020


#vnet1
#create vnet1-subnet1 vm
az vm create --resource-group az300networks101 --name vnet1-vm1 --image UbuntuLTS --vnet-name vnet1 --subnet vnet1-subnet1 \
--admin-username glongchi --admin-password Adminsupport@2020


az vm create --resource-group az300networks101 --name vnet1-vm-mgmt1 --image UbuntuLTS --vnet-name vnet1 --subnet vnet1-subnet1 \
--admin-username glongchi --admin-password Adminsupport@2020


#create vnet1-subnet2 vm
az vm create --resource-group az300networks101 --name vnet1-vm-web1 --image UbuntuLTS --vnet-name vnet1 --subnet vnet1-subnet2 \
--admin-username glongchi --admin-password Adminsupport@2020

#vnetOnprem