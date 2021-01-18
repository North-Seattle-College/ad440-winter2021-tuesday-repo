## Input Parameters      
$location="westus2" ## Get all the locations for your Azure Subscription: Get-AzLocation | select Location  
$resourceGroupName="ad440-tuesday-team2-rg"  
$storageAccName="ad440tuesteam2strgeacct"   
 
## Connect to Azure Account  
Connect-AzAccount   
 
## Function to create Azure Storage Account  
Function CreateAzStorageAcc{   
    ## Check if resource group exists      
    if(Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)  
    {  
         Write-Host -ForegroundColor Magenta $resourceGroupName "- resource group already exists."  
    }  
    else  
    {  
         Write-Host -ForegroundColor Magenta $resourceGroupName "- resource group does not exist."  
         Write-Host -ForegroundColor Green "Creating th resource group - " $resourceGroupName  
 
         ## Create a new resource group  
         New-AzResourceGroup -Name $resourceGroupName -Location $location  
    }   
 
    ## Check if storage account exists  
    if(Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName -ErrorAction SilentlyContinue)  
    {  
         Write-Host -ForegroundColor Magenta $storageAccName "- storage account already exists."     
    }  
    else  
    {  
         Write-Host -ForegroundColor Magenta $storageAccName "- storage account does not exist."  
         Write-Host -ForegroundColor Green "Creating the storage account - " $storageAccName   
 
         ## Create a new Azure Storage Account  
         New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName -Location $location -SkuName Standard_LRS   
    }  
}   
  
CreateAzStorageAcc  
 
## Disconnect from Azure Account  
Disconnect-AzAccount  