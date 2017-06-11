#Sample Execution

##Validate ARM template
Test-AzureRmResourceGroupDeployment -ResourceGroupName eyc3wintestrg `
-TemplateFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withoutencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly.json" `
-TemplateParameterFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withoutencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly-parameters.json"

##Run ARM template
New-AzureRmResourceGroupDeployment -Name TestDeploymentDev1 `
-ResourceGroupName eyc3wintestrg -TemplateFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withoutencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly.json" `
-TemplateParameterFile "C:\Users\rethesh.krishnan\Desktop\test\Linux\withoutencrypt\test-linux-mddisk-as-md-bkp-omsscript-privateiponly-parameters.json"