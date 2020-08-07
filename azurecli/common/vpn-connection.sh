
#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#reference Link: https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-cli
#Script Purpose
# - define a group of common functions to be called else where
###########################################################################################


#4
function createGatewaySubnet(){
resoruceGroup=$1
name=$2  # example naming convention MyVnet1ToMyVnet2
vnetName=$3 # vnetname
addressPrefix=$4 #Resource ID or name of the remote VNet.
location=$5
nowait=$6

az network vnet subnet create  --resource-group $resoruceGroup \
 --vnet-name $vnetName
 --address-prefix $addressPrefix \
 --name GatewaySubnet \
}




az network local-gateway create --gateway-ip-address
                                --name
                                --resource-group
                                [--asn]
                                [--bgp-peering-address]
                                [--local-address-prefixes]
                                [--location]
                                [--no-wait]
                                [--peer-weight]
                                [--subscription]
                                [--tags]

#5
# The local network gateway typically refers to your on-premises location. You give the site a name by which Azure can refer to it,
#  then specify the IP address of the on-premises VPN device to which you will create a connection. 
#  You also specify the IP address prefixes that will be routed through the VPN gateway to the VPN device. 
#  The address prefixes you specify are the prefixes located on your on-premises network. 
#  If your on-premises network changes, you can easily update the prefixes.
function createLocalGateway(){

resoruceGroup=$1
siteName=$2  # give the site a name by which Azure can refer to it
vnetName=$3 # vnetname
localaddressPrefixes=$5 #example  10.0.0.0/24 20.0.0.0/24
gatewayIpAddress=$6
location=$5
nowait=$6

az network local-gateway create  --resource-group $resoruceGroup \
 --gateway-ip-address $gatewayIpAddress \
  --name $siteName \
  --local-address-prefixes $localaddressPrefixes
}

#6
# A VPN gateway must have a Public IP address. You first request the IP address resource, and then refer to it 
# when creating your virtual network gateway. The IP address is dynamically assigned to the resource when the 
# VPN gateway is created. VPN Gateway currently only supports Dynamic Public IP address allocation. You cannot
#  request a Static Public IP address assignment. However, this does not mean that the IP address changes 
#  after it has been assigned to your VPN gateway. The only time the Public IP address changes is when 
#  the gateway is deleted and re-created. It doesn't change across resizing, resetting, or other internal
#  maintenance/upgrades of your VPN gateway.
function createVpnPublicIpAddress(){
    resoruceGroup=$1
    publicIpName=$2
    allocatedMethod=$3 # Dynamic, Static
    az network public-ip create --resource-group $resoruceGroup \
    --name $publicIpName \
    --allocation-method $allocatedMethod
}

#7
# Create the virtual network VPN gateway. Creating a VPN gateway can take up to 45 minutes or more to complete.
function createVpnGateway(){
    resoruceGroup=$1
    vpnGatewayName=$2 # can also call vnetGateway when doing vnet to vnet connection using gateway(not peering)
    publicIpAddress=$3
    vnetName=$4 # vnetname
    gatewayType=$4
    vpnType=$5 #RouteBased, PolicyBased
    sku=$6 # example VpnGw1, VpnGw2

az network vnet-gateway create --resource-group $resoruceGroup \
--name $vpnGatewayName \
--public-ip-address $publicIpAddress \
--vnet $vnetName \
--gateway-type $gatewayType \
--vpn-type $vpnType 
--sku $sku \
--no-wait 

}



# az network vpn-connection update [--add]
#                                  [--enable-bgp {false, true}]
#                                  [--express-route-gateway-bypass {false, true}]
#                                  [--force-string]
#                                  [--ids]
#                                  [--name]
#                                  [--remove]
#                                  [--resource-group]
#                                  [--routing-weight]
#                                  [--set]
#                                  [--shared-key]
#                                  [--subscription]
#                                  [--tags]
#                                  [--use-policy-based-traffic-selectors {false, true}]
function createVpnConnection(){


az network vpn-connection create  --resource-group TestRG1 \
--name VNet1toSite2--vnet-gateway1 VNet1GW -\
l eastus --shared-key abc123 --local-gateway2 Site2

}