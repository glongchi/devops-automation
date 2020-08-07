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





#################################################################     VPN CONNECTION   ############################################################
#vpn connection : vnetHub <--> vnetOnprem
#local gateway: the local network gateway refers to the vpn gateway details of the remote location
az network local-gateway create --gateway-ip-address 23.99.221.164 --name local-network-gateway-vnet-hub --resource-group az300networks101 \
 --local-address-prefixes 10.254.0.0/16  --asn 65002 --no-wait


#public ip:vnetHub-gw-ip
az network public-ip create --name vnetHub-gw-ip --resource-group az300networks101 --allocation-method Dynamic


#public ip: onprem-vpngw-ip1
az network public-ip create --name onprem-vpngw-ip1 --resource-group az300networks101 --allocation-method Dynamic

#vpn gateway vnetHub
az network vnet-gateway create --name vnetHub-vpn-gw --public-ip-address vnetHub-gw-ip --resource-group az300networks101 --vnet vnetHub \
 --gateway-type Vpn --vpn-type RouteBased --asn 65001 --sku VpnGw1 --no-wait

 #vpn gateway vnetOnprem
az network vnet-gateway create --name vnetHub-vpn-gw --public-ip-address onprem-vpngw-ip1 --resource-group az300networks101 --vnet vnetHub \
 --gateway-type Vpn --vpn-type RouteBased --asn 65002 --sku VpnGw1 --no-wait



 #vpn gateway onprem
az network vnet-gateway create --name onprem-vpn-gw --public-ip-address vnetHub-gw-ip --resource-group az300networks101 --vnet vnetOnprem \
 --gateway-type Vpn --vpn-type RouteBased --asn 65002 --sku VpnGw1 --no-wait


#vpn connection

