#Sample Execution


##Validate ARM template
Test-AzureRmResourceGroupDeployment -ResourceGroupName eyc3wintestrg `
-TemplateFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly-encrypted.json" `
-TemplateParameterFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly-encrypted-parameters.json"

##Run ARM template
New-AzureRmResourceGroupDeployment -Name TestDeploymentDev1 `
-ResourceGroupName eyc3wintestrg -TemplateFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly-encrypted.json" `
-TemplateParameterFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly-encrypted-parameters.json