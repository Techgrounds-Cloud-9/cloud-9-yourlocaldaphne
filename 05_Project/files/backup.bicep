param rsvName string = 'web-recovery'
param bkpolName string = 'web-backup'
param location string
param protectedItemName string
// param vmName string

// //Referencing vm
// resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' existing = {
//   name: vmName
// }

resource rsv 'Microsoft.RecoveryServices/vaults@2020-02-02' = {
  name: rsvName
  location: location
  sku: {
    name: 'RS0'
  }
  properties: {}
}

//Backup policies
resource bkpol 'Microsoft.RecoveryServices/vaults/backupPolicies@2022-09-01-preview' = {
  name: bkpolName
  location: location
  parent: rsv
  properties: {
    backupManagementType: 'AzureIaasVM'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
    }
    retentionPolicy: {
      retentionPolicyType: 'SimpleRetentionPolicy'
      retentionDuration: {
        count: 1
        durationType: 'Weeks'
      }
    }
  }
}

resource protectedItems 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2022-04-01' = {
  name: protectedItemName
  location: location
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: bkpol.id
  }
  dependsOn: [
    rsv
  ]
}

