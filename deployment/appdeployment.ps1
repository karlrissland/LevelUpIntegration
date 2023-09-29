## Store Master deployment script
## Call the script using the following command
##   .\appdeployment.ps1 -SubscriptionId "{SubscriptionId}" -ResourceGroupName "{ResourceGroupName}" -KeyVaultName "{KeyVaultName}"
##
## Note: you will have to make sure you have access to the keyvault.  In the portal, go to the keyvault and add yourself as a keyvault access policy with secret permissions

## Note: this script assumes you have the necessary CLI tools installed and configured on your local machine.  You will need;
##  - Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
##  - Azure PowerShell (https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-6.13.0)
##  - Azure Functions Core Tools (https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#v2)

param(
    [string]$SubscriptionId,
    [string]$ResourceGroupName,
    [string]$KeyVaultName
)

$ErrorActionPreference = "Stop"

##----------------------------------------------
## Fetch values from KeyVault
Write-Host "- Fetching values from KeyVault and Setting up variables"

#### Set KeyVault Access Policy for current user.  Note: you must have the correct user permissions to do this
$userUPN = Invoke-Expression "az ad signed-in-user show --query userPrincipalName -o tsv"
az keyvault set-policy --name $KeyVaultName --resource-group $ResourceGroupName --upn $userUPN --secret-permissions get list set

$batch_AzureBlob_InboundContainerName = "inbound"
$batch_AzureBlob_OutboundContainerName = "outbound"
$AzureBlob_ImageContainerName = "images"
$batch_AzureBlob_connectionString = Invoke-Expression "az keyvault secret show --name 'storagePrimaryConnStr' --vault-name $KeyVaultName --query value -o tsv" 
$openaiEndpoint = Invoke-Expression "az keyvault secret show --name 'openaiEndpoint' --vault-name $KeyVaultName --query value -o tsv" 
$openaiKey = Invoke-Expression "az keyvault secret show --name 'openaiKey' --vault-name $KeyVaultName --query value -o tsv" 
$opanaiName = Invoke-Expression "az keyvault secret show --name 'openaiName' --vault-name $KeyVaultName --query value -o tsv" 
$logicAppName = Invoke-Expression "az keyvault secret show --name 'logicAppName' --vault-name $KeyVaultName --query value -o tsv" 

Write-Host "- Variable setup complete"

##----------------------------------------------
## Deploy Azure Logic Apps
Write-Host "- Setting up Logic App"
$files = Get-ChildItem -Path ../ -File 
$directories = Get-ChildItem -Path ../ -Recurse -Directory -Exclude "deployment", "docs", "infrastructure", "sample-messages"
Compress-Archive -Path $($files + $directories) -DestinationPath LogicApp.zip
az logicapp deployment source config-zip --name $LogicAppName  --resource-group $resourceGroupName --subscription $SubscriptionId --src LogicApp.zip
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "AzureBlob_connectionString=$batch_AzureBlob_connectionString"
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "AzureBlob_InboundContainerName=$batch_AzureBlob_InboundContainerName"
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "AzureBlob_OutboundContainerName=$batch_AzureBlob_OutboundContainerName"
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "AzureBlob_ImageContainerName=$AzureBlob_ImageContainerName"
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "openaiEndpoint=$openaiEndpoint"
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "openaiKey=$openaiKey"
az logicapp config appsettings set --name $logicAppName --resource-group $resourceGroupName --subscription $SubscriptionId --settings "openaiName=$opanaiName"
Write-Host "- Logic App Setup Complete"