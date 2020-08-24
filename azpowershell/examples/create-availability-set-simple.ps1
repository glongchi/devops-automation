


# Define variables for resource names
$resourceGroupName = "myResourceGroup"
$scaleSetName = "myScaleSet"
$location = "EastUS"


# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

#Create a managed availability set using New-AzAvailabilitySet with the -sku aligned parameter.

# Create a virtual network subnet
$subnet = New-AzVirtualNetworkSubnetConfig `
  -Name "mySubnet" `
  -AddressPrefix 10.0.0.0/24

  # Create a virtual network
$vnet = New-AzVirtualNetwork `
-ResourceGroupName $resourceGroupName `
-Name "myVnet" `
-Location $location `
-AddressPrefix 10.0.0.0/16 `
-Subnet $subnet