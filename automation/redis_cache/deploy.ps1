param(
        [string] $TemplateFile = './template.json'
      )  

# Short check if redis already exists
$RedisExists = (Get-AzRedisCache -ResourceGroupName $ResourceGroupName -Name $RedisServerName) 
      
# Does redis exist
if (!$RedisExists) { 
    Write-Host "Creating new Redis Cache..."
    New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile
} else {
    Write-Host "Redis Cache with name " $RedisServerName "already exists."
}
