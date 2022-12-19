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
param rsvName string 
param bkpolName string 

var backupFabric = 'Azure'
var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${nameSpace}'
var protectedItem = 'vm;iaasvmcontainerv2;${resourceGroup().name};${nameSpace}'


resource rsv 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: rsvName
  location: location
  identity: {
    type: 'UserAssigned'
  }
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    // encryption: {
    //   kekIdentity: {
    //     userAssignedIdentity: ''
    //   }
    // }
  }
  
}

//Backup policies
resource bkpol 'Microsoft.RecoveryServices/vaults/backupPolicies@2022-09-01-preview' = {
  name: bkpolName
  location: location
  parent: rsv
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: 2
    schedulePolicy: {
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '21:00'
      ]
      schedulePolicyType: 'SimpleSchedulePolicy'
    }
    retentionPolicy: {
      dailySchedule: {
        retentionTimes: [
          '21:00'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
      retentionPolicyType: 'LongTermRetentionPolicy'
    }
    timeZone: 'W. Europe Standard Time'
  }
}

resource vaultName_backupFabric_protectionContainer_protectedItem 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2022-09-01-preview' = {
  name: '${rsvName}/${backupFabric}/${protectionContainer}/${protectedItem}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: '${rsv.id}/backupPolicies/${bkpolName}'
    sourceResourceId: vm.id
  }
} 

//Storage account to store the bootstrapscript in
resource st 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'st${nameSpace}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
  }
}

//Blob for bootstrapscript
resource service 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: st
}

//Container for bootstrapscript
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'bootstrapscripts'
  parent: service
}

//Deployment script for the bootstrapscript
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-blob'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.42.0'
    timeout: 'PT5M' // Times out after 5 minutes
    retentionInterval: 'PT1H' // ISO 8601 duration for 5 minutes, then deletes it
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: st.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: st.listKeys().keys[0].value
      }
    ]
    scriptContent: 'echo "${bootstrapScript}" > ${vm.name}-bootstrap && az storage blob upload -f ${vm.name}-bootstrap -c ${container.name} -n ${vm.name}-bootstrap'
  }
}

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
output vmId string = vm.id
// output rsv string = rsv.id
