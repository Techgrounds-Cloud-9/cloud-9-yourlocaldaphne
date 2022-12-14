param rsvName string = 'web-recovery'
param bkpolName string = 'web-backup'
param location string

resource rsv 'Microsoft.RecoveryServices/vaults@2020-02-02' = {
  name: rsvName
  location: location
  sku: {
    name: 'RS0'
  }
  properties: {}
}

resource bkpol 'Microsoft.RecoveryServices/vaults/backupPolicies@2022-09-01-preview' = {
  name: bkpolName
  location: location
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
