# LevelUpIntegration

## Local Development Setup
Note: we are unable to provide a codespace for LogicApp Standard Development as GitHub codespaces only support linux containers and LogicApp Standard requires Windows containers.

Pre-requisites 

Required Software:
- Azure CLI
- Azure Functions Core Tools
- Visual Studio Code
- .NET Core SDK

Required vscode extensions:
- Azurite.azurite 
- ms-vscode.azurecli 
- ms-vscode.azure-account 
- ms-dotnettools.csharp 
- ms-dotnettools.csdevkit 
- ms-azuretools.azure-dev 
- ms-azuretools.vscode-azurefunctions 
- ms-azuretools.vscode-azurelogicapps 
- ms-azuretools.data-mapper-vscode-extension 

## Getting Started
1. Clone the repo
2. Open the repo in vscode
3. Open the terminal in vscode  
4. Run `az login` to login to your azure account
5. Run `az account set --subscription <subscription id>` to set the subscription you want to use
6. Navigate to the deployoment directory and run `./checkenvironment.ps1` to check if you have all the required components installed locally

If you are missing any required components, please install and rerun the checkenvironment script until you have all the required components installed.

When everything looks good, head over to the workshop to get started; [workshop](docs/workshop.md)