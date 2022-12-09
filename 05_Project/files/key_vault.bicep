param location string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-project-daphne-07'
  location: location
  properties: {
    accessPolicies: []
    enabledForDiskEncryption: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
  }
}
output keyVaultId string = kv.id
output keyVaultName string = kv.name
