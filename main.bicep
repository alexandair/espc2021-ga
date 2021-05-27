param location string = resourceGroup().location
param storageAccountName string = 'espc2021${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'espc2021${uniqueString(resourceGroup().id)}'

@allowed([
  'dev'
  'prod'
])
param environment string

var storageAccountSkuName = (environment == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environment: environment
  }
}

output webAppHostName string = appService.outputs.webAppHostName

