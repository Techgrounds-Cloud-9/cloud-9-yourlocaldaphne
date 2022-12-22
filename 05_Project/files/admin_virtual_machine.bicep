param location string
param nameSpace string
param bootstrapScript string = ''
param vmSize string
param serverType string
param publisher string
param OSversion string
param adminUsername string
param adminKey string
param keyVaultName string
param encryptionKey string = newGuid() //generates random string
param staticIp bool = false
param subnetId string
param rgName string

var extensionName = 'AzureDiskEncryption'
var keyVaultResourceID = resourceId(rgName, 'Microsoft.KeyVault/vaults/', kv.name)

// Caling Key Vault
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource DiskEncryption 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${nameSpace}/${extensionName}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Security'
    type: 'AzureDiskEncryptionForLinux'
    typeHandlerVersion: '1.1'
    autoUpgradeMinorVersion: true
    forceUpdateTag: '1.0'
    settings: {
      EncryptionOperation: 'EnableEncryption'
      KeyVaultURL: reference(kv.id, '2019-09-01').vaultUri
      KeyVaultResourceId: keyVaultResourceID
      KeyEncryptionAlgorithm: 'RSA-OAEP'
      VolumeType: 'All'
      ResizeOSDisk: false
    }
  }
}

// //Creating encryption for the Virtual Machine's disk.
// resource diskEncryptionSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
//   name: 'vm-${nameSpace}-disk'
//   parent: kv
//   tags: {
//     DiskEncryptionKeyFileName: 'encryptionKeyProject'
//     DiskEncryptionKeyEncryptionAlgorithm: 'RSA-OAEP'
//   }
//   properties: {
//     value: encryptionKey
//   }
// }

// The Virtual Machine with it's coresponding subnet and IP.
resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: nameSpace
  location: location
  properties: {
    networkProfile: {
      networkApiVersion: '2020-11-01'
      networkInterfaceConfigurations: [ {
          name: 'nic-${nameSpace}'
          properties: {
            ipConfigurations: [ {
                name: 'ipConfig-${nameSpace}'
                properties: {
                  subnet: {
                    id: subnetId
                  }
                  publicIPAddressConfiguration: {
                    name: 'pip-${nameSpace}'
                    sku: {
                      name: 'Basic'
                      tier: 'Regional'
                    }
                    properties: {
                      deleteOption: 'Delete'
                      publicIPAddressVersion: 'IPv4'
                      publicIPAllocationMethod: staticIp ? 'Static' : 'Dynamic' //conditional or ternary operator, very nice
                    }
                  }
                }
              } ]
          }
        } ]
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        offer: serverType
        publisher: publisher
        sku: OSversion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        encryptionSettings: {
          enabled: true
          // diskEncryptionKey: {
          //   secretUrl: diskEncryptionSecret.properties.secretUriWithVersion
          //   sourceVault: {
          //     id: kv.id
          //   }
          // }
        }
      }
    }
    osProfile: {
      computerName: 'vm-${nameSpace}'
      adminUsername: adminUsername
      adminPassword: adminKey
      customData: base64(bootstrapScript)
    }
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'pip-${nameSpace}'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    deleteOption: 'Delete'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: staticIp ? 'Static' : 'Dynamic' //conditional operator, very nice
  }
}

output vmName string = vm.name
