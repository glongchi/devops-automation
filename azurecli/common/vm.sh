
#!/bin/bash
###########################################################################################
# az 300 tutorial
# Longchi Kanouo - @koomzo
#
#Script Purpose
# - define a group of common functions to be called else where
###########################################################################################

function createVm(){


resoruceGroup=$1
vmName=$2
image=$3 # UbuntuLTS
vnetName=$4
subnetName=$5
adminUser=glongchi
adminPassword=Adminsupport@27
az vm create --resource-group $resoruceGroup \
--name $vmName \
--image $image \
--vnet-name $vnetName \
--subnet $subnetName \
--admin-username $adminUser \
--admin-password $adminPassword

}
