
param resourceName string

@description('Location for all resources.')
param location string = resourceGroup().location

param keyVaultName string

param appInsightsInstrumentationKey string

var LogicAppPlan_name = 'wp-${resourceName}'
var LogicApp_Name = resourceName
var prelim_LogicAppStorageName = replace(toLower('lgstorage${resourceName}'),'-','')
var managementbaseuri = environment().resourceManager

//substring will fail if the string isn't long enough, so need to test to see if needed
var LogicApp_Storage_Name = (length(prelim_LogicAppStorageName)<24 ? prelim_LogicAppStorageName :substring(prelim_LogicAppStorageName,0,23))

resource storageAccounts_WorkflowPlanStorage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: LogicApp_Storage_Name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion:'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource:'Microsoft.Storage'
    }
  }
}

//Build the storage account connection string
var storagePrimaryKey = storageAccounts_WorkflowPlanStorage.listKeys().keys[0].value
var storageprimaryConnStr = 'DefaultEndpointsProtocol=https;AccountName=${LogicApp_Storage_Name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storagePrimaryKey}'

resource workflowplan_serverfarms 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: LogicAppPlan_name
  location: location
  sku: {
    name: 'WS1'
    tier: 'WorkflowStandard'
    size: 'WS1'
    family: 'WS'
    capacity: 1
  }
  kind: 'elastic'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: true
    maximumElasticWorkerCount: 20
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_schemagen_name_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: LogicApp_Name
  location: location
  kind: 'functionapp,workflowapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: workflowplan_serverfarms.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
      appSettings:[
        {
        name: 'APP_KIND  '
        value: 'workflowapp'
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageprimaryConnStr
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageprimaryConnStr
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'

        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'

        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'

        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'

        }
        // {
        //   name: 'WEBSITE_CONTENTSHARE'
        //   value: toLower(workloadName)

        // }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'

        }
        {
          name: 'WORKFLOWS_TENANT_ID'
          value: subscription().tenantId
        }
        {
          name: 'WORKFLOWS_SUBSCRIPTION_ID'
          value: subscription().id
        }
        {
          name: 'WORKFLOWS_RESOURCE_GROUP_NAME'
          value: resourceGroup().name
        }
        {
          name: 'WORKFLOWS_LOCATION_NAME'
          value: location
        }
        {
          name: 'WORKFLOWS_MANAGEMENT_BASE_URI'
          value: managementbaseuri
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
      ]
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

//store the info in KeyVault
resource SecretsKeyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName

  resource kvLogicAppPlanId 'secrets@2021-10-01' = {name: 'logicAppPlanId', properties:{value: workflowplan_serverfarms.id}}
  resource kvLogicAppPlanName 'secrets@2021-10-01' = {name: 'logicAppPlanName', properties:{value: LogicAppPlan_name}}
  resource kvLogicAppName 'secrets@2021-10-01' = {name: 'logicAppName', properties:{value: LogicApp_Name}}
  resource kvLogicAppStorageName 'secrets@2021-10-01' = {name: 'logicAppStorageName', properties:{value: LogicApp_Storage_Name}}
}

