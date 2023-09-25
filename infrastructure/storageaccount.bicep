param resourceName string

@description('Location for all resources.')
param location string = resourceGroup().location

param keyVaultName string

var storageAccountName = replace('genstor${toLower(substring(resourceName,0,8))}','-','')
var storeMasterContainerName = 'storemaster'
var ASNContainerName = 'asn'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku:{
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource storageAccountsBlobServices_resource 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource storeMasterStorageAccountsContainer_resource 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: storageAccountsBlobServices_resource
  name: storeMasterContainerName
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

resource ASNStorageAccountsContainer_resource 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: storageAccountsBlobServices_resource
  name: ASNContainerName
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

//get the primary key and generate the connection string
var storagePrimaryKey = storageAccount.listKeys().keys[0].value
var storagePrimaryConnStr = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storagePrimaryKey}'

//store the primary key and the connection string in an already provisioned key vault
resource SecretsKeyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName

  resource kvStoragePrimaryKey 'secrets@2021-10-01' = {name: 'storagePrimaryKey', properties:{value: storagePrimaryKey}}
  resource kvStoragePrimaryConnStr 'secrets@2021-10-01' = {name: 'storagePrimaryConnStr', properties:{value: storagePrimaryConnStr}}
  resource kvStorageAccountName 'secrets@2021-10-01' = {name: 'storageAccountName', properties:{value: storageAccountName}}
}
