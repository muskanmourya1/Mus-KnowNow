@description('Azure Region for deployment')
param location string = resourceGroup().location

@description('App Service Plan Name')
param appServicePlanName string = 'AppServicePlan'

@description('App Service Names')
param appServiceNames array = [
  'WebApp1'
  'WebApp2'
]

@description('Azure OpenAI Service Name')
param openAIServiceName string = 'OpenAIService'

@description('Azure OpenAI GPT-4 Name')
param gpt4ServiceName string = 'GPT4Service'

@description('Azure AI Search Service Name')
param aiSearchServiceName string = 'AISearchService'

@description('Azure AI Document Intelligence Service Name')
param documentAIServiceName string = 'DocumentAIService'

@description('Logic App Service Name')
param logicAppName string = 'LogicAppService'

@description('Storage Account Name')
param storageAccountName string = 'storageacct'

@description('Azure OpenAI Ada Token Limit')
param adaTokenLimit int = 5000000

@description('Azure OpenAI GPT-4 User Days')
param gpt4UserDays int = 132

@description('Document Intelligence Pre-built Limit')
param docIntelligencePrebuilt int = 10000

@description('Document Intelligence OCR Limit')
param docIntelligenceOCR int = 10000

@description('Storage Account Size (GB)')
param storageSizeGB int = 250

@description('Storage Account Operations')
param storageOperations int = 100000

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    capacity: 2
  }
}

// App Services
resource appServices 'Microsoft.Web/sites@2022-03-01' = [for appName in appServiceNames: {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}]

// Azure AI Search Service
resource aiSearchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: aiSearchServiceName
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
}

// Azure OpenAI Service (Ada Model)
resource openAIService 'Microsoft.CognitiveServices/accounts@2022-12-01' = {
  name: openAIServiceName
  location: location
  sku: {
    name: 'ada'
    capacity: adaTokenLimit
  }
}

// Azure OpenAI Service (GPT-4)
resource gpt4Service 'Microsoft.CognitiveServices/accounts@2022-12-01' = {
  name: gpt4ServiceName
  location: location
  sku: {
    name: 'gpt4'
    capacity: gpt4UserDays
  }
}

// Azure AI Document Intelligence Service
resource documentAIService 'Microsoft.CognitiveServices/accounts@2022-12-01' = {
  name: documentAIServiceName
  location: location
  sku: {
    name: 'standard'
    capacity: docIntelligencePrebuilt + docIntelligenceOCR
  }
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// Logic Apps
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  sku: {
    name: 'Standard'
    capacity: 300
  }
}
