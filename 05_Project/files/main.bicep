module rg './resource_group.bicep' = {
  scope: subscription()
  name: 'resourceGroupDeploy'
  params: {
    name: 'rg-project'
    location: 'westeurope'
  }
}

module kv './key_vault.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    location: 'westeurope'
  }
}

module vnet './virtual_network.bicep' = {
  name: 'virtualNetworkDeploy'
  params: {
    nameSpace: ''
    location: 'westeurope'
    addressSpace: ''
    securityRules: [
      
    ]
  }
}

module vm './virtual_machine.bicep' = {
  name: 'virtualMachineDeploy'
  params: {
    location: 'westeurope'
    nameSpace: ''
    vmSize: ''
    serverType: ''
    OSversion: ''
    adminUsername: ''
    adminKey: ''
    keyVaultName: ''
  }
}
