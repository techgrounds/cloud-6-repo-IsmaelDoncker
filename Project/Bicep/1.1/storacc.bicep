@minLength(3)
@maxLength(24)
param storageAccountName string = toLower('storacc${uniqueString(resourceGroup().id)}')
param location string = resourceGroup().location
param Man_in string
param keyurlin string 
//param utcValue string = utcNow()
param apachefile string = 'webserver.sh'      //'zscript.sh'
param kvkey string

var script64 = loadFileAsBase64('./scripts/webserver.sh') 



resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  identity: {
    type: 'UserAssigned' 
    userAssignedIdentities: {
      '${Man_in}': {}
    }
  }
  sku:{
    name: 'Standard_LRS' 
  } 
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }

    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: false
    allowBlobPublicAccess: false
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    largeFileSharesState: 'Disabled'
    allowSharedKeyAccess: true
    encryption: {
      identity: {
        userAssignedIdentity: Man_in // added
      }
      requireInfrastructureEncryption: false // added
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
         keyname: kvkey //'RSAkey'   //KEY.name    
         keyvaulturi: keyurlin
      }
      services: {
        blob: {
          enabled: true
        }
        file:  {
          enabled: true
        }
         queue: {
           enabled: true
         }
         table: {
           enabled:true
         }
      }
    }
  }
}

resource BLOB 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  name: 'default'
  parent: storageaccount
  properties: {
    containerDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
    changeFeed: {
      enabled: false
    }
    automaticSnapshotPolicyEnabled: true
    isVersioningEnabled: true
    restorePolicy: {
      enabled: false
      days: 7
    }

  }
}

resource BLOB_CON 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01'={
  parent: BLOB
  name: 'script64'
  properties: {
    publicAccess: 'None'
  }
}

resource DEPLOY_SCRIPT 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript' //'deployscript-upload-blob-${utcValue}'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.28.0'      //'2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    cleanupPreference: 'Always' //'OnSuccess' // added 26-03
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value:  storageAccountName   //store_name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageaccount.listKeys().keys[0].value
      }
      {
        name: 'CONTENT'
        value: loadFileAsBase64('./scripts/webserver.sh')
      }
    ]
    
    scriptContent: 'echo $CONTENT | base64 -d > ${apachefile} && az storage blob upload -f ${apachefile} -c ${script64} -n ${apachefile}'
  }
}

output private_out string = storageaccount.properties.primaryEndpoints.blob
