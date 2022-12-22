targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-project'
  location: 'westeurope'
}

// module kv './key_vault.bicep' = {
//   scope: rg
//   name: 'keyVaultDeploy'
//   params: {
//     kvName: 'kv-project-daphne-79'
//     location: 'westeurope'
//     rsvName: vm_webserver.outputs.rsv.name
//   }
// }

module vnet_webserver './virtual_network.bicep' = {
  scope: rg
  name: 'virtualNetworkWebserverDeploy'
  params: {
    nameSpace: 'webserver'
    location: 'westeurope'
    addressSpace: '10.10.10.0/24'
    securityRules: [
      {
        name: 'security-rules-web'
        properties: {
          access: 'Allow'
          destinationPortRange: '*'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '80'
          destinationAddressPrefix: '*'
          priority: 120
        }
      }
    ]
  }
}

module peering_webserver './peering.bicep' = {
  scope: rg
  name: 'peeringWebserverDeploy'
  params: {
    nameSpace: 'peeringWebserver'
    vnetName: vnet_webserver.outputs.vnetName
    remoteVnetId: vnet_adminserver.outputs.vnetId
  }
}

module vm_webserver './web_virtual_machine.bicep' = {
  scope: rg
  name: 'virtualMachineWebserverDeploy'
  params: {
    location: 'westeurope'
    nameSpace: 'webserver'
    subnetId: vnet_webserver.outputs.subnetId
    vmSize: 'Standard_B1s'
    serverType: 'UbuntuServer'
    publisher: 'Canonical'
    OSversion: '19.04'
    adminUsername: 'Daphne'
    adminKey: 'DaphneProject123!'
    // keyVaultName: kv.outputs.keyVaultName
    staticIp: true
    rsvName: 'webserver'
    bkpolName: 'web-backup'
    kvName: 'kv-project-daphne-83'
    rgName: rg.name
    // userName: 'user-daphne'
  }
}

module vnet_adminserver './virtual_network.bicep' = {
  scope: rg
  name: 'virtualNetworkAdminserverDeploy'
  params: {
    nameSpace: 'adminserver'
    location: 'westeurope'
    addressSpace: '10.20.20.0/24'
    securityRules: [
      {
        name: 'security-rules-admin'
        properties: {
          access: 'Allow'
          destinationPortRange: '3389'
          direction: 'Inbound'
          protocol: '*'
          sourceAddressPrefix: '193.53.104.0'
          sourcePortRange: '80'
          destinationAddressPrefix: '*'
          priority: 110
        }
      }
    ]
  }
}

module peering_adminserver './peering.bicep' = {
  scope: rg
  name: 'peeringAdminserverDeploy'
  params: {
    nameSpace: 'peeringAdminserver'
    vnetName: vnet_adminserver.outputs.vnetName
    remoteVnetId: vnet_webserver.outputs.vnetId
  }
}

module vm_adminserver './admin_virtual_machine.bicep' = {
  scope: rg
  name: 'virtualMachineAdminserverDeploy'
  params: {
    location: 'westeurope'
    nameSpace: 'adminserver'
    subnetId: vnet_adminserver.outputs.subnetId
    vmSize: 'Standard_B1s'
    serverType: 'WindowsServer'
    publisher: 'MicrosoftWindowsServer'
    OSversion: '2019-Datacenter'
    adminUsername: 'Daphne'
    adminKey: 'DaphneProject123!'
    keyVaultName: vm_webserver.outputs.kvName
    staticIp: false
    rgName: rg.name
  }
}
