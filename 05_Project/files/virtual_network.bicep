param location string = 'westeurope'
param addressSpace string
param nameSpace string
param securityRules array

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
          addressPrefixes: [
            addressSpace
          ]
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

// need total of 2 vnets and 2 subnets
// NSG needs to protect subnets
// public ip, http/https ports open, auto install apache 

// De volgende IP ranges worden gebruikt: 10.10.10.0/24 & 10.20.20.0/24
