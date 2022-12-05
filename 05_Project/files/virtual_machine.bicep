param location string
param nameSpace string
param bootstrapScript string = ''
param vmSize string
param serverType string
param OSversion string
param adminUsername string
param adminKey string
param keyVaultName string
param encryptionKey string = newGuid()

resource st 'Microsoft.Storage/storageAccounts@2022-05-01' = if (!empty(bootstrapScript)) {
  name: 'st${nameSpace}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
  }
}

resource service 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: st
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'bootstraps'
  parent: service
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (!empty(bootstrapScript)) {
  name: 'deployscript-upload-blob'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.42.0'
    timeout: 'PT5M' // Times out after 5 minutes
    retentionInterval: 'PT5M' // ISO 8601 duration for 5 minutes, then deletes it
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: st.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: st.listKeys().keys[0].value
      }
    ]
    scriptContent: 'echo "${bootstrapScript}" > ${vm.name}-bootstrap && az storage blob upload -f ${vm.name}-bootstrap -c ${container.name} -n ${vm.name}-bootstrap'
  }
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource diskEncryptionSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'vm-${nameSpace}-disk'
  parent: kv
  properties: {
    value: encryptionKey
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: 'vm-${nameSpace}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        offer: serverType
        sku: OSversion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        encryptionSettings: {
          enabled: true
          diskEncryptionKey: {
            secretUrl: diskEncryptionSecret.properties.secretUri
            sourceVault: {
              id: kv.id
            }
          }
        }
      }
    }
    osProfile: {
      computerName: 'vm-${nameSpace}'
      adminUsername: adminUsername
      adminPassword: adminKey
      customData: base64(bootstrapScript)
    }
  }
}
