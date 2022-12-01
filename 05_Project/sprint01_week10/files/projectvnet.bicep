param storageAcountName string = 'projectvnet'
param storageAcountLocation string = 'westeurope'

resource symbolicname 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: storageAcountName
  location: storageAcountLocation
    }
