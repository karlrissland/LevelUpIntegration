# LevelUpIntegration

## Local Development Setup
Note: we are unable to provide a codespace for LogicApp Standard Development as GitHub codespaces only support linux containers and LogicApp Standard requires Windows containers.

Pre-requisites 

to be installed on your local machine:
- Azurite
- Azure Storage Explorer
- Azure CLI
- Azure Functions Core Tools
- Visual Studio Code
- .NET Core SDK
- Microsoft Azure Storage Explorer

Extensions to be installed in Visual Studio Code:
- Azure Logic Apps (Standard)
- Azure Functions
- Azure Logic Apps - Data Mapper
- Azurite


To run the project locally, you will need to have Azurite running. Azurite is a local emulator for Azure Storage. You can install it via the visual studio code marketplace.

Once installed, you can create the two required containers by running the following commands in the terminal:

```
az storage container create --name inbound --connection-string "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;"

az storage container create --name outbound --connection-string "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;"
```

The Azurite AccountKey and AccountName default to the values above. If you have changed these values, you will need to update the connection strings in the commands above.

The connection string you will use with the storage account connector is the following:

```
"DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;"
```

Install Microsoft Azure Storage Explorer to view and manage the contents of the containers.  This can be done with WinGet

```
 winget install Microsoft.Azure.StorageExplorer  
```
