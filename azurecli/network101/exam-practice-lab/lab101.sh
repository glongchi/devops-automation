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

#create vNet0
az network vnet create --name vNet0 --resource-group practice --address-prefix 10.0.0.0/16 
az network vnet subnet create --address-prefix 10.0.0.0/24 --name subnet0 --resource-group practice --vnet-name vNet0 --no-wait
az network firewall create -g practice -n fireawall --private-ranges 10.0.10.0/24


#hub public ip:vNet0-gw-ip
az network public-ip create --name vNet0-gw-ip --resource-group practice --allocation-method Dynamic


#public ip: onprem-vpngw-ip1
az network public-ip create --name onprem-vpngw-ip1 --resource-group az300networks101 --allocation-method Dynamic

az network vnet subnet create --address-prefix 10.0.254.0/27 --name GatewaySubnet--resource-group az300networks101 --vnet-name vnet0 --no-wait

#2 Deploy a VPN Gateway called vpngw (don’t wait for it to finish)

#3.Add two spoke vNets, called vnet1 and vnet2
#create vNet1 and subnet1
az network vnet create --name vNet1 --resource-group practice --address-prefix 10.1.0.0/16 
az network vnet subnet create --address-prefix 10.1.1.0/24 --name subnet0 --resource-group practice --vnet-name vNet1 --no-wait


#create vNet2 and subnet2 and subnet3
az network vnet create --name vNet2 --resource-group practice --address-prefix 10.2.0.0/16 
az network vnet subnet create --address-prefix 10.2.2.0/24 --name subnet2 --resource-group practice --vnet-name vNet2 --no-wait
az network vnet subnet create --address-prefix 10.2.3.0/24 --name subnet3 --resource-group practice --vnet-name vNet2 --no-wait



# 4.vNet peer both spokes vNets to the hub vNet
#Peerings are established between virtual network IDs, so you must first get the ID of each virtual network 
#with az network vnet show and store the ID in a variable.

# Get the id for VNet1.
vNet0Id=$(az network vnet show --resource-group practice --name vNet0 --query id --out tsv)
vNet1Id=$(az network vnet show --resource-group practice --name vNet1 --query id --out tsv)
vNet2Id=$(az network vnet show --resource-group practice --name vNet2 --query id --out tsv)


#vnet0<-->vnet1
az network vnet peering create -g practice -n LinkVnet0ToVnet1 --vnet-name vNet0  \
    --remote-vnet $vNet1Id --allow-vnet-access  \
   --allow-forwarded-traffic  --allow-gateway-transit

#vnet1<-->vnet0
az network vnet peering create -g practice -n LinkVnet1ToVnet0 --vnet-name vNet1  \
    --remote-vnet $vNet0Id --allow-vnet-access 
  # --use-remote-gateways set this parameter after gateway as been set on remote network









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