param location string = 'westeurope'


resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-project'
  location: location
  properties: {
    enabledForDiskEncryption: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
  }
}
output keyVaultId string = kv.id
