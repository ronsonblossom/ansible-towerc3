#Sample execution

##Validate ARM template
Test-AzureRmResourceGroupDeployment -ResourceGroupName eyc3wintestrg `
-TemplateFile "C:\Users\rethesh.krishnan\Desktop\test\Windows\withoutencrypt\testservermanaged-Windows-as-md-am-oms-backup-privateiponly.json" `
-TemplateParameterFile "C:\Users\rethesh.krishnan\Desktop\test\Windows\withoutencrypt\testservermanaged-Windows-as-md-am-oms-backup-privateiponly-parameter.json"

##Run ARM template
New-AzureRmResourceGroupDeployment -Name TestDeploymentDev1 `
-ResourceGroupName eyc3wintestrg -TemplateFile "C:\Users\rethesh.krishnan\Desktop\test\Windows\withoutencrypt\testservermanaged-Windows-as-md-am-oms-backup-privateiponly.json" `
-TemplateParameterFile "C:\Users\rethesh.krishnan\Desktop\test\Windows\withoutencrypt\testservermanaged-Windows-as-md-am-oms-backup-privateiponly-parameter.json"

