param sites_demo68365_name string = 'demo68365'
param serverfarms_demo68365_asp_name string = 'demo68365-asp'
param registries_demo68365_name string = 'demo68365'
param containerGroups_demo68365_name string = 'demo68365'

resource containerGroups_demo68365_name_resource 'Microsoft.ContainerInstance/containerGroups@2024-05-01-preview' = {
  name: containerGroups_demo68365_name
  location: 'canadacentral'
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: containerGroups_demo68365_name
        properties: {
          image: '${containerGroups_demo68365_name}.azurecr.io/demo-webapp-68365:v1'
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
            {
              protocol: 'TCP'
              port: 8080
            }
          ]
          environmentVariables: []
          configMap: {
            keyValuePairs: {}
          }
          resources: {
            requests: {
              memoryInGB: json('1.5')
              cpu: 1
            }
          }
        }
      }
    ]
    initContainers: []
    imageRegistryCredentials: [
      {
        server: '${containerGroups_demo68365_name}.azurecr.io'
        username: containerGroups_demo68365_name
      }
    ]
    restartPolicy: 'OnFailure'
    osType: 'Linux'
  }
}

resource registries_demo68365_name_resource 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: registries_demo68365_name
  location: 'canadacentral'
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
      azureADAuthenticationAsArmPolicy: {
        status: 'enabled'
      }
      softDeletePolicy: {
        retentionDays: 7
        status: 'disabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
    metadataSearch: 'Disabled'
  }
}

resource serverfarms_demo68365_asp_name_resource 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: serverfarms_demo68365_asp_name
  location: 'Canada Central'
  sku: {
    name: 'P0v3'
    tier: 'Premium0V3'
    size: 'P0v3'
    family: 'Pv3'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource registries_demo68365_name_repositories_admin 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-11-01-preview' = {
  parent: registries_demo68365_name_resource
  name: '_repositories_admin'
  properties: {
    description: 'Can perform all read, write and delete operations on the registry'
    actions: [
      'repositories/*/metadata/read'
      'repositories/*/metadata/write'
      'repositories/*/content/read'
      'repositories/*/content/write'
      'repositories/*/content/delete'
    ]
  }
}

resource registries_demo68365_name_repositories_pull 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-11-01-preview' = {
  parent: registries_demo68365_name_resource
  name: '_repositories_pull'
  properties: {
    description: 'Can pull any repository of the registry'
    actions: [
      'repositories/*/content/read'
    ]
  }
}

resource registries_demo68365_name_repositories_pull_metadata_read 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-11-01-preview' = {
  parent: registries_demo68365_name_resource
  name: '_repositories_pull_metadata_read'
  properties: {
    description: 'Can perform all read operations on the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/metadata/read'
    ]
  }
}

resource registries_demo68365_name_repositories_push 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-11-01-preview' = {
  parent: registries_demo68365_name_resource
  name: '_repositories_push'
  properties: {
    description: 'Can push to any repository of the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}

resource registries_demo68365_name_repositories_push_metadata_write 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-11-01-preview' = {
  parent: registries_demo68365_name_resource
  name: '_repositories_push_metadata_write'
  properties: {
    description: 'Can perform all read and write operations on the registry'
    actions: [
      'repositories/*/metadata/read'
      'repositories/*/metadata/write'
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}

resource sites_demo68365_name_resource 'Microsoft.Web/sites@2023-12-01' = {
  name: sites_demo68365_name
  location: 'Canada Central'
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_demo68365_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_demo68365_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_demo68365_asp_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNETCORE|8.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: '8C28EE57703A4FE63D5969BAFE5F0EBEA0BA19E76422D978981B6BA1E5EDC60E'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_demo68365_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: sites_demo68365_name_resource
  name: 'ftp'
  location: 'Canada Central'
  properties: {
    allow: false
  }
}

resource sites_demo68365_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: sites_demo68365_name_resource
  name: 'scm'
  location: 'Canada Central'
  properties: {
    allow: false
  }
}

resource sites_demo68365_name_web 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: sites_demo68365_name_resource
  name: 'web'
  location: 'Canada Central'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOTNETCORE|8.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: 'REDACTED'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: true
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: true
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_demo68365_name_b8219230_551b_4230_a425_0a121803e9b2 'Microsoft.Web/sites/deployments@2023-12-01' = {
  parent: sites_demo68365_name_resource
  name: 'b8219230-551b-4230-a425-0a121803e9b2'
  location: 'Canada Central'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'OneDeploy'
    message: 'OneDeploy'
    start_time: '2024-09-23T17:37:13.6189294Z'
    end_time: '2024-09-23T17:37:19.3595442Z'
    active: true
  }
}

resource sites_demo68365_name_sites_demo68365_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2023-12-01' = {
  parent: sites_demo68365_name_resource
  name: '${sites_demo68365_name}.azurewebsites.net'
  location: 'Canada Central'
  properties: {
    siteName: 'demo68365'
    hostNameType: 'Verified'
  }
}
