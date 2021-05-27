param location string
param appServiceAppName string

@allowed([
  'dev'
  'prod'
])
param environment string

var appServicePlanName = 'espc2021-plan'
var appServicePlanSkuName = (environment == 'prod') ? 'P2_v3' : 'F1'
var appServicePlanTierName = (environment == 'prod') ? 'PremiumV3' : 'Free'

resource appServicePlan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
}

resource webApp 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output webAppHostName string = webApp.properties.defaultHostName
