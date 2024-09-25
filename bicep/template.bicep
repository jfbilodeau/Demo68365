param webAppName string
param location string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${webAppName}-plan'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
}

resource webApp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output webAppEndpoint string = webApp.properties.defaultHostName
