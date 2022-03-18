[CmdletBinding()]
param (
    [string] $ResourceGroupName = "aspnet-yarp-container-demo-rg",
    [string] $ContainerAppEnvResourceGroupName = $ResourceGroupName,
    [string] $ContainerAppEnvName = "",

    [Parameter(Mandatory=$true)]
    [string] $KeyVaultName,
    [Parameter(Mandatory=$true)]
    [string] $keyVaultResourceGroupName
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 4.0

$here = Split-Path -Parent $PSCommandPath

$armParams = @{
    useExistingEnv = ($ContainerAppEnvName -ne "")
    envResourceGroup = $ContainerAppEnvResourceGroupName
    envName = $ContainerAppEnvName

    catalog_api_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsapiscatalog:0.2.1"
    orders_api_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsapisorders:0.2.1"
    ui_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsapisui:0.2.1"
    yarp_image = "ghcr.io/endjin/aspnetcorewithyarponazurecontainerapps/dotnetoncontainerappsproxy:0.2.1"
    registry = "ghcr.io"
    registryUsername = ""
    registryPassword = ""
    keyVaultName = $KeyVaultName
    keyVaultResourceGroupName = $keyVaultResourceGroupName
}

New-AzResourceGroup `
    -Name $ResourceGroupName `
    -Location "northeurope" `
    -Verbose `
    -Force

New-AzResourceGroupDeployment `
    -Name "main" `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile "$here/deploy/main.bicep" `
    -TemplateParameterObject $armParams `
    -Verbose