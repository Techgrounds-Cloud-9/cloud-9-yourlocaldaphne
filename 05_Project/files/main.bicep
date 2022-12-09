// module rg './resource_gromain-221208-1512up.bicep' = {
//   scope: subscription()
//   name: 'resourceGroupDeploy'
//   params: {
//     name: 'rg-project'
//     location: 'westeurope'
//   }
// }
targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-project'
  location: 'westeurope'
}

module kv './key_vault.bicep' = {
  scope: rg
  name: 'keyVaultDeploy'
  params: {
    location: 'westeurope'
  }
}

module vnet_webserver './virtual_network.bicep' = {
  scope: rg
  name: 'virtualNetworkWebserverDeploy'
  params: {
    nameSpace: 'webserver'
    location: 'westeurope'
    addressSpace: '10.10.10.0/24'
    securityRules: [

    ]
  }
}

module vm_webserver './virtual_machine.bicep' = {
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
    keyVaultName: kv.outputs.keyVaultName
    staticIp: true
  }
}

// module vnet_adminserver './virtual_network.bicep' = {
// scope: rg
//   name: 'virtualNetworkAdminserverDeploy'
//   params: {
//     nameSpace: 'adminserver'
//     location: 'westeurope'
//     addressSpace: '10.20.20.0/24'
//     securityRules: [

//     ]
//   }
// }

// module vm_adminserver './virtual_machine.bicep' = {
// scope: rg
//   name: 'virtualMachineAdminserverDeploy'
//   params: {
//     location: 'westeurope'
//     nameSpace: 'adminserver'
//     subnetId: vnet_adminserver.outputs.subnetId
//     vmSize: 'Basic_A0'
//     serverType: 'Windows'
//     publisher: 'MicrosoftWindowsServer'
//     OSversion: '2022-datacenter-azure-edition'
//     adminUsername: 'Daphne'
//     adminKey: 'DaphneProject123!'
//     keyVaultName: kv.name
//     staticIp: false
//   }
// }
