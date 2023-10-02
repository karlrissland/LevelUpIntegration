$MissingSomething = [bool]::Parse("false")

# Check if the needed components are installed
Write-Host "------------------------------------"
Write-Host "Checking Azure CLI"
try{ az --version }
catch
    { 
        Write-Host ">>>> Azure CLI not installed.  Please install and try again" 
        $MissingSomething = [bool]::Parse("true")
    }
Write-Host ""

Write-Host "------------------------------------"
Write-Host "Checking Azure Functions Core Tools"
try {
    $funcVersion = func --version
    Write-Host "Azure Functions Core Tools version: $funcVersion"
    }
catch 
    { 
        Write-Host ">>>> Azure Functions Core Tools not installed.  Please install and try again" 
        $MissingSomething = [bool]::Parse("true")
    }
Write-Host ""

Write-Host "------------------------------------"
Write-Host "Checking Visual Studio Code"
try {
    $funcVersion = code --version
    Write-Host "Visual Studio Code version: $funcVersion"
    }
catch 
    { 
        Write-Host ">>>> Visual Studio Code not installed.  Please install and try again" 
        $MissingSomething = [bool]::Parse("true")
    }
Write-Host ""

# check if the needed vs code extensions are installed
Write-Host "------------------------------------"
Write-Host "Checking Visual Studio Code Extensions"

$listofextensions= code --list-extensions

if ($listofextensions -notcontains "Azurite.azurite") {
    Write-Host ">>>> Azurite.azurite extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension Azurite.azurite"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- Azurite.azurite extension installed"
}

if ($listofextensions -notcontains "ms-vscode.azurecli") {
    Write-Host ">>>> ms-vscode.azurecli extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-vscode.azurecli"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-vscode.azurecli extension installed"
}

if ($listofextensions -notcontains "ms-vscode.azure-account") {
    Write-Host ">>>> ms-vscode.azure-account extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-vscode.azure-account"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-vscode.azure-account extension installed"
}

if ($listofextensions -notcontains "ms-dotnettools.csharp") {
    Write-Host ">>>> ms-dotnettools.csharp extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-dotnettools.csharp"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-dotnettools.csharp extension installed"
}

if ($listofextensions -notcontains "ms-dotnettools.csdevkit") {
    Write-Host ">>>> ms-dotnettools.csdevkit extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-dotnettools.csdevkit"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-dotnettools.csdevkit extension installed"
}

if ($listofextensions -notcontains "ms-azuretools.azure-dev") {
    Write-Host ">>>> ms-azuretools.azure-dev extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-azuretools.azure-dev"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-azuretools.azure-dev extension installed"
}

if ($listofextensions -notcontains "ms-azuretools.vscode-azurefunctions") {
    Write-Host ">>>> ms-azuretools.vscode-azurefunctions extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-azuretools.vscode-azurefunctions"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-azuretools.vscode-azurefunctions extension installed"
}

if ($listofextensions -notcontains "ms-azuretools.vscode-azurelogicapps") {
    Write-Host ">>>> ms-azuretools.vscode-azurelogicapps extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-azuretools.vscode-azurelogicapps"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-azuretools.vscode-azurelogicapps extension installed"
}

if ($listofextensions -notcontains "ms-azuretools.data-mapper-vscode-extension") {
    Write-Host ">>>> ms-azuretools.data-mapper-vscode-extension extension not installed.  Please install and try again"
    Write-Host ">>>> You can install it by running the following command in a terminal window:"
    Write-Host ">>>> code --install-extension ms-azuretools.data-mapper-vscode-extension"
    $MissingSomething = [bool]::Parse("true")
} else {
    Write-Host "- ms-azuretools.data-mapper-vscode-extension extension installed"
}

# Did we run into any problems?
if ($MissingSomething)
    {
        Write-Host "------------------------------------"
        Write-Host "One or more components are missing. "
        Write-Host "Please review the log above and install the missing components before continuing"
    }
    else {
        Write-Host "------------------------------------"
        Write-Host "Everything looks good.  You are ready to go!"
    }









