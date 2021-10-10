Import-Module Az.Compute

# Set your own subscription ID and tenant ID
$subscriptionId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$tenantId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"

# Sign in to your Azure subscription
Connect-AzAccount -SubscriptionId $subscriptionId -TenantId $tenantId -Identity

# If you have multiple subscriptions, set the one to use

$vms = Get-AzVM

$vms | ForEach-Object `
-Begin {Write-Output("VM STOP START")} `
-Process `
{
    if(-Not($_.ResourceGroupName.Contains("RESOURCEGROUP-HANDSON-LAB-JAPANEAST-001")))
    { 
        Write-Output("ignore resource id:{0}" -f $_.Id)
    }
    else
    {
        Stop-AzVM -Force -Name $_.Name -ResourceGroupName $_.ResourceGroupName
    }
} `
-End { Write-Output("VM STOP END")}