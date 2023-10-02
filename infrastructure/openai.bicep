param resourceName string

@description('Location for all resources.')
param location string = resourceGroup().location

param keyVaultName string

resource cogservice_resource 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: resourceName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: resourceName
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

var openaiKey = cogservice_resource.listKeys().key1
var openaiEndpoint = cogservice_resource.properties.endpoint
var openaiName = resourceName

//store the primary key and the connection string in an already provisioned key vault
resource SecretsKeyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName

  resource kvOpenaiKey 'secrets@2021-10-01' = {name: 'openaiKey', properties:{value: openaiKey}}
  resource kvOpenaiEndpoint 'secrets@2021-10-01' = {name: 'openaiEndpoint', properties:{value: openaiEndpoint}}
  resource kvOpenaiName 'secrets@2021-10-01' = {name: 'openaiName', properties:{value: openaiName}}
}
