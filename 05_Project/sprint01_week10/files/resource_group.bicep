targetScope = 'subscription'
param resourceGroupName string = 'rg-project'
param resourceGroupLocation string = 'westeurope'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}
