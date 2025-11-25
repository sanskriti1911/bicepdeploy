
// main.bicep - Root module calling child modules with explicit dependency
// Scope: resource group deployment

@description('Prefix used to create unique resource names (letters and numbers only recommended).')
param namePrefix string = 'demo'

@description('Azure region for deployment. Default uses the resource group location.')
param location string = resourceGroup().location

@description('App Service Plan SKU (e.g., F1, B1, P1v3).')
param appServicePlanSku string = 'B1'

@description('Storage Account SKU name.')
param storageSkuName string = 'Standard_LRS'

@description('Storage Account kind.')
param storageKind string = 'StorageV2'

// Child module: Storage Account
module storage './modules/storage.bicep' = {
  name: '${namePrefix}-storage-module'
  params: {
    namePrefix: namePrefix
    location: location
    skuName: storageSkuName
    kind: storageKind
  }
}

// Child module: App Service Plan + Web App
// Demonstrates dependency: web module waits for storage module and consumes its output
module web './modules/webapp.bicep' = {
  name: '${namePrefix}-web-module'
  params: {
    namePrefix: namePrefix
    location: location
    appServicePlanSku: appServicePlanSku
    storageConnectionString: storage.outputs.primaryConnectionString
  }
}

output webUrl string = web.outputs.webAppName
