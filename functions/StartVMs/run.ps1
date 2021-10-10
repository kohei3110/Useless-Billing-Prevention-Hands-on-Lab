using namespace System.Net

# Input bindings are passed in via param block.
param($Timer, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "Start-VM function processed a request."

# Interact with query parameters or the body of the request.
$resourceGroup = $env:resourceGroup
Write-Verbose "resourceGroup: $resourceGroup"

$resourceType = "Microsoft.Compute/virtualMachines"

$devResources = (Get-AzResource -ResourceType $resourceType -ResourceGroupName $resourceGroup -TagValue "DEV").Name
Write-Verbose "Dev Resources Name: $devResources"

foreach ($resourceName in $devResources)
{
    try {
        Start-AzVM -ResourceGroupName $resourceGroup -Name $resourceName -NoWait
    }
    catch {
        Write-Host $PSItem.ToString()
        throw $PSItem
    }    
}