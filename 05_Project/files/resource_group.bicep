targetScope = 'subscription'
param name string 
param location string 

// Resource group for the project.
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
}

output name string = rg.name
