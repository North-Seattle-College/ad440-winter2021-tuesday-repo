#sign into azure account 
Connect-AzAccount

#Create a local function project
#Choose folder name
$foldername = Read-Host -Prompt "Enter a name for your folder" 

#create local function project in powershell
func init $foldername --powershell

#navigate into the project folder
cd $foldername

#create unique name for HTTP Trigger function
$functionname = Read-Host -Prompt "Name your function"
#add function to the project
func new --name $functionname --template "HTTP trigger" --authlevel "anonymous"

$resourceGroupName = Read-Host -Prompt "Name your resource group"
$location = 'West US 2'
$templateUri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-function-app-create-dynamic/azuredeploy.json"

#Create new resource group and deploy template
New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri

func start

<# publish function to azure
$functionappname = Read-Host -Prompt "Name your function APP"
func azure functionapp publish $functionappname #>