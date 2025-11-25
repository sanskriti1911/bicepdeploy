
// modules/webapp.bicep - Child module that deploys App Service Plan + Web App

@description('Name prefix for resources.')
param namePrefix string

@description('Azure region for deployment.')
param location string

@description('App Service Plan SKU (e.g., F1, B1, S1, P1v3).')
param appServicePlanSku string = 'B1'

@description('Storage connection string from the storage module.')
param storageConnectionString string

var unique = uniqueString(resourceGroup().id)
var planName = toLower(replace('${namePrefix}-asp', ' ', ''))
var siteName = toLower(replace('${namePrefix}-web-${unique}', ' ', ''))

// Infer tier from SKU prefix


var tier = 'Free'





resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: planName
  location: location
  sku: {
    name: appServicePlanSku
    tier: tier
    size: appServicePlanSku
    capacity: 1
  }
}

resource site 'Microsoft.Web/sites@2022-03-01' = {
  name: siteName
  location: location
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'StorageConnectionString'
          value: storageConnectionString
        }
      ]
    }
    httpsOnly: true
  }
}

output webAppName string = site.name

