param location string
param nameSpace string
param bootstrapScript string = ''
// param vmSize string
param serverType string
param publisher string
param OSversion string
param adminUsername string
param adminKey string
param kvName string
param staticIp bool = false
param subnetId string
param rsvName string
param bkpolName string
param rgName string
param accpolName string = 'add'

param instanceCount int = 1
param nsgId string 

// param apgwName string

// param lbName string
// param bpoolName string
// param natPoolName string
// param natStartPort int
// param natEndPort int
// param natBackendPort int
// param probeName string
// param healthprobeprotocol string
// param healthprobeprot int

// var lbPoolID = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, bpoolName)

var backupFabric = 'Azure'
var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${nameSpace}'
var protectedItem = 'vm;iaasvmcontainerv2;${resourceGroup().name};${nameSpace}'

// var extensionName = 'AzureDiskEncryption'
var keyVaultResourceID = resourceId(rgName, 'Microsoft.KeyVault/vaults/', kvName)

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: kvName
}

resource kvaccpol 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: accpolName
  parent: kv
  properties: {
    accessPolicies: [
      {
        objectId: rsv.identity.principalId
        permissions: {
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
          storage: [
            'all'
          ]
        }
        tenantId: tenant().tenantId
      }
    ]
  }
}

resource rsv 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: rsvName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
  }
}

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
    sourceResourceId: vmScaleSet.id
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
    timeout: 'PT20M' 
    retentionInterval: 'PT1H' // 
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: st.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: st.listKeys().keys[0].value
      }
      {
        name: 'CONTENT'
        value: loadTextContent('./bootstrapscript.sh')
      }
    ]
    scriptContent: 'echo "$CONTENT" > ${vmScaleSet.name}-bootstrap && az storage blob upload -f ${vmScaleSet.name}-bootstrap -c ${container.name} -n ${vmScaleSet.name}-bootstrap'
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
    publicIPAllocationMethod: staticIp ? 'Static' : 'Dynamic' //conditional operator
  }
}

resource vmScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2022-08-01' = {
  name: nameSpace
  location: location
  sku: {
    name: 'Standard_B2ms'
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    overprovision: true
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          caching: 'ReadWrite'
          createOption: 'FromImage'
        }
        imageReference: {
          offer: serverType
          publisher: publisher
          sku: OSversion
          version: 'latest'
        }
      }
      osProfile: {
        computerNamePrefix: nameSpace
        adminUsername: adminUsername
        adminPassword: adminKey
        customData: base64(bootstrapScript)
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nic-${nameSpace}'
            properties: {
              primary: true
              ipConfigurations: [ {
              name: 'ipConfig-${nameSpace}'
              properties: {
               subnet: {
                 id: subnetId
                 }
                  publicIPAddressConfiguration: {
                    name: 'pip-${nameSpace}'
                    sku: {
                      name: 'Standard'
                      tier: 'Regional'
                    }
                    properties: {
                      publicIPAddressVersion: 'IPv4'
                    }
                  }
                }
              } ]
              networkSecurityGroup: {
                id: nsgId
              }
            }
          }
        ]
      }
    }
  }
}

// resource appgw 'Microsoft.Network/applicationGateways@2022-07-01' = {
//   name: apgwName
//   location: location
//   properties: {
//   }
// }

resource autoscalehost 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: 'autoscalehost'
  location: location
  properties: {
    name: 'autoscalehost'
    targetResourceUri: vmScaleSet.id
    enabled: true
    profiles: [
      {
        name: 'Profile1'
        capacity: {
          minimum: '1'
          maximum: '3'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: vmScaleSet.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 50
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT2M'
            }
          }
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: vmScaleSet.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 30
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
}

output rsvIdentity string = rsv.identity.principalId
output kvIdentity string = keyVaultResourceID
output stName string = st.name
