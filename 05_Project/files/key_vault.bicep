param location string
param kvName string 

// Key Vault for storing the encryption of the Virtual Machines.
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: kvName
  location: location
  properties: {
    accessPolicies: []
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enabledForTemplateDeployment:true
    enablePurgeProtection: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
  }
}

resource accpol 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: kv
  properties: {
    accessPolicies: [
      {
        objectId: '1641adce-1f8d-4381-9729-40f0ef6f522b'
        permissions: {
          keys: [
            'all'
            'get'
            'list'
            'backup'
          ]
          secrets: [
            'all'
            'get'
            'list'
            'backup'
          ]
          storage: [
            'all'
            'get'
            'list'
            'backup'
          ]
        }
        tenantId: tenant().tenantId
      }
    ]
  }
}

output keyVaultId string = kv.id
output keyVaultName string = kv.name
