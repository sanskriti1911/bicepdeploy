
// modules/storage.bicep - Child module that deploys a Storage Account

@description('Name prefix (kept lowercase and sanitized).')
param namePrefix string

@description('Azure region for deployment.')
param location string

@description('Storage SKU name (e.g., Standard_LRS).')
param skuName string = 'Standard_LRS'

@description('Storage kind, typically StorageV2.')
param kind string = 'StorageV2'

// Create a valid storage account name: 3-24 chars, lowercase letters/numbers only


var saName ='sans1119s'

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: saName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

// Build a connection string using the primary key
var primaryKey = listKeys(sa.id, '2021-09-01').keys[0].value
var connectionString = 'DefaultEndpointsProtocol=https;AccountName=${sa.name};AccountKey=${primaryKey};EndpointSuffix=${environment().suffixes.storage}'

output accountName string = sa.name
output primaryConnectionString string = connectionString
