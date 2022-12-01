// not done yet
param storageAcountName string = 'projectstorage'
param storageAcountLocation string = 'westeurope'

resource symbolicname 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAcountName
  location: storageAcountLocation
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
      }
    }
