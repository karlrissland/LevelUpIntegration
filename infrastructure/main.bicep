//Infrastructure for Ingestion of IoT Data into Azure
targetScope = 'subscription'

@description('The environment for which the deployment is intended')
@allowed(['dev', 'test', 'prod'])
param environment string = 'dev'

param location string = deployment().location

//variables
var ResourceGroupName = 'levelupIntegration-${environment}'
var uniqueSuffix = substring(uniqueString(ResourceGroupName),0,6)
var resourceSuffix = '${uniqueSuffix}-${environment}'
var keyVaultName = 'kv-${resourceSuffix}'
var logAnalyticsWorkspaceName = 'la-ingest-${resourceSuffix}'
var appInsightsName = 'ai-${resourceSuffix}'
var logicAppName = 'logic-${resourceSuffix}'
var storageName = 'st${resourceSuffix}'
var openaiName = 'openai-${resourceSuffix}'


resource RG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: ResourceGroupName
  location: location
}

module KeyVaultDeploy 'keyvault.bicep' = {
  name: 'keyvault'
  scope: RG
  params: {
    resourceName: keyVaultName
    location: location
  }
}

module StorageDeploy 'storageaccount.bicep' = {
  name: 'storage'
  scope: RG
  params: {
    resourceName: storageName
    location: location
    keyVaultName: keyVaultName
  }
  dependsOn: [KeyVaultDeploy]
}

module AppInsights 'appinsights.bicep' = {
  name: 'appinsights'
  scope: RG
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    applicationInsightsName: appInsightsName
    location: location
  }
}

module openaiDeploy 'openai.bicep' = {
  name: 'openai'
  scope: RG
  params: {
    resourceName: openaiName
    location: location
    keyVaultName: keyVaultName
  }
  dependsOn: [KeyVaultDeploy]
}

module LogicAppDeploy 'logicapp.bicep' = {
  name: 'logicapp'
  scope: RG
  params: {
    resourceName: logicAppName
    location: location
    keyVaultName: keyVaultName
    appInsightsInstrumentationKey: AppInsights.outputs.appInsightsInstrumentationKey
  }
  dependsOn: [KeyVaultDeploy]
}
