param location string

// Key Vault for storing the encryption of the Virtual Machines.
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-project-daphne-10'
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
