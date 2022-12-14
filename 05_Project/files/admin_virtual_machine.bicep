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

// Caling Key Vault
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

//Creating encryption for the Virtual Machine's disk.
resource diskEncryptionSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'vm-${nameSpace}-disk'
  parent: kv
  tags: {
    DiskEncryptionKeyFileName: 'encryptionKeyProject'
    DiskEncryptionKeyEncryptionAlgorithm: 'RSA-OAEP'
  }
  properties: {
    value: encryptionKey
  }
}

// The Virtual Machine with it's coresponding subnet and IP.
resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: 'vm-${nameSpace}'
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
          diskEncryptionKey: {
            secretUrl: diskEncryptionSecret.properties.secretUriWithVersion
            sourceVault: {
              id: kv.id
            }
          }
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
