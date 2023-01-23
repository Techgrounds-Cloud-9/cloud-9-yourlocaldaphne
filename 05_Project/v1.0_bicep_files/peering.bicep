param nameSpace string
param vnetName string
param remoteVnetId string

//Referencing vnet
resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetName
}

//Peering made for the two Virtual Networks
resource peer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: 'peer-${nameSpace}'
  parent: vnet
  properties: {
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}
