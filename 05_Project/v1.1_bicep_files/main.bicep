targetScope = 'subscription'
param location string = 'westeurope'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-project'
  location: location
}

module vnet_webserver './vnet-web-admin.bicep' = {
  scope: rg
  name: 'virtualNetworkWebserverDeploy'
  params: {
    nameSpace: 'webserver'
    location: 'westeurope'
    addressSpace: '10.10.10.0/24'
    securityRules: [
      {
        name: 'default-allow-22'
        properties: {
          priority: 110
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 120
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
       }
       {
        name: 'default-allow-80'
        properties: {
          priority: 130
          access: 'Allow'
          direction: 'Inbound'  
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
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

module kv './kv.bicep' = {

  scope: rg
  name: 'keyVaultDeploy'
  params: {
    kvName: 'daphne-project-bicep'
    location: 'westeurope' 
  }
}

module vm_webserver './vm-web.bicep' = {
  scope: rg
  name: 'virtualMachineWebserverDeploy'
  params: {
    location: 'westeurope'
    nameSpace: 'webserver'
    subnetId: vnet_webserver.outputs.subnetId
    serverType: 'UbuntuServer'
    publisher: 'Canonical'
    OSversion: '18.04-LTS'
    adminUsername: 'Daphne'
    adminKey: 'DaphneProject123!'
    kvName: kv.outputs.kvName
    staticIp: true
    bkpolName: 'bkpol-webserver'
    rgName: rg.name
    rsvName: 'rsv-webserver'
    bootstrapScript: loadTextContent('./bootstrapscript.sh')
    nsgId: vnet_webserver.outputs.nsgId
    // apgwName: 'app-gateway-webserver'
  }
}

module vnet_adminserver './vnet-web-admin.bicep' = {
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
          sourcePortRange: '*'
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

module vm_adminserver './vm-admin.bicep' = {
  scope: rg
  name: 'virtualMachineAdminserverDeploy'
  params: {
    location: 'westeurope'
    nameSpace: 'adminserver'
    subnetId: vnet_adminserver.outputs.subnetId
    vmSize: 'Standard_B1s'
    serverType: 'WindowsServer'
    publisher: 'MicrosoftWindowsServer'
    OSversion: '2019-datacenter-gensecond'
    adminUsername: 'Daphne'
    adminKey: 'DaphneProject123!'
    keyVaultName: kv.outputs.kvName
    staticIp: false
    rgName: rg.name
  }
}
