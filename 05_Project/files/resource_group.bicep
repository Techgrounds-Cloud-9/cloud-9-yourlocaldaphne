targetScope = 'subscription'
param nameRg string 
// param nameSpace string
param location string 

// Resource group for the project.
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: nameRg
  location: location
}

output name string = rg.name
