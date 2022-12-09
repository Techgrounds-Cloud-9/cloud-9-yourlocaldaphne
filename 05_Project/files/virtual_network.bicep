param location string
param addressSpace string
param nameSpace string
param securityRules array = []
param peeredVnetId string = ''

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: 'nsg-${nameSpace}'
  location: location
  properties: {
    securityRules: securityRules
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'vnet-${nameSpace}'
  location: location
  dependsOn: [ nsg ]
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: [
      {
        name: 'snet-${nameSpace}'
        properties: {
          addressPrefix: addressSpace
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

//needs 2 vnet
resource peer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = if (!empty(peeredVnetId)) {
  name: 'peer-${nameSpace}'
  parent: vnet
  properties: {
    remoteVirtualNetwork: {
      id: peeredVnetId
    }
  }
}

output subnetId string = vnet.properties.subnets[0].id
