## Need to start Azurite via visual studio code before running this script
Write-Host "Please start Azurite via Visual Studio Code before running this script"
Read-Host -Prompt "Press Enter to continue"

## Assuming scripts are being run from the deployment directory

## create the local.settings.json file

$path = "..\local.settings.json"
$storageConnStr = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;"

if (Test-Path $path) 
{
    Write-Host "local.settings.json File Exists"
    Write-Host "no action taken"
}
else 
{
    Write-Host "local.settings.json File Does Not Exist"
    Write-Host "creating file"
    $jsonString = '{'
    $jsonString = $jsonString + '  "IsEncrypted": false,'
    $jsonString = $jsonString + '  "Values": {'
    $jsonString = $jsonString + '      "AzureWebJobsStorage": "UseDevelopmentStorage=true",'
    $jsonString = $jsonString + '      "APP_KIND": "workflowapp",'
    $jsonString = $jsonString + '      "FUNCTIONS_WORKER_RUNTIME": "node",'
    $jsonString = $jsonString + '      "WORKFLOWS_SUBSCRIPTION_ID": "",'
    $jsonString = $jsonString + '      "AzureBlob_connectionString": "' + $storageConnStr + '"'
    $jsonString = $jsonString + '  }'
    $jsonString = $jsonString + '}'

    Set-Content -Path $path -Value $jsonString

    Write-Host "local.settings.json File Created"
}


## create the local containers in Azurite

az storage container create --name inbound --connection-string $storageConnStr

az storage container create --name outbound --connection-string $storageConnStr

write-host "an inbound and outbound container have been created in Azurite"