@description('the name of the environment. this must be dev, test, or prod')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('the unique name of the solution. this is used to ensure that resource names are unqiues')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('the number of App Service plan instancess')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU')
param appServicePlanSku object 

@description('the azure region into which the resources should be deployeds')
param location string = resourceGroup().location

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-apps'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name:appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
