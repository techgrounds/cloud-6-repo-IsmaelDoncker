param location string = resourceGroup().location
@minLength(3)
@maxLength(24)
param storageAccountName string = toLower('storacc${uniqueString(resourceGroup().id)}')
param vaultName1 string = 'recovery${uniqueString(resourceGroup().id)}'
param vaultName string = 'keyVault1${uniqueString(resourceGroup().id)}'
/* param sku string = 'Standard' */
param tenant string = subscription().tenantId  //'de60b253-74bd-4365-b598-b9e55a2b208d' // replace if needed tenantId
/*param accessPolicies array = [
  {
    tenantId: tenant
    objectId: '' // replace with your objectId
    permissions: {
      keys: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      secrets: [
        'Get'
        'List'
        'Set'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      certificates: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'ManageContacts'
        'ManageIssuers'
        'GetIssuers'
        'ListIssuers'
        'SetIssuers'
        'DeleteIssuers'
      ]
    }
  }
] */

@description('Change Vault Storage Type()')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('name of backup policy')
param policyName string = 'mypolicy${uniqueString(resourceGroup().id)}'

/// KEYVAULT,KEYS,ENCRYPT - PARAM ///

param DISKencryptionsetname string = 'DiskEncryption'



@description('The name of Management Server')
param adminUsername string = 'winadmin'

@description('the password for the Management Server')
@minLength(12)
@secure()
param adminPassword string

@description('DNS Mangement S')
param dnsLabelPrefix string = toLower('MS${vmName}-${uniqueString(resourceGroup().id, vmName)}') // check later 

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix1 string = toLower('simplelinuxvm-${uniqueString(resourceGroup().id)}')

@description('WindowsIp')
param publicIpName string = 'ManagementPublicIP'

@description('linuxIP')
param publicIpName1 string = 'AppPublicIP'

@description('IP type')
@allowed([
  'Static'
  'Dynamic'
])
param publicIPAllocationMethod string = 'Dynamic'

@description('')
param publicIpSku string = 'Basic'

@description('OS images')
@allowed([
  '2019-Datacenter'
  '2022-Datacenter'
  '20_04-lts-gen2'
])
param OSVersion string = '2019-Datacenter'
param ubuntuOSVersion string = '20_04-lts-gen2'

@description('')
param vmSize string = 'Standard_B2s'

@description('The name of Management Server VM')
param vmName string = 'WinServer'

@description('The name of you Web Server Virtual Machine.')
param vmName1 string = 'Web-Server'

@description('Username for the Virtual Machine WebServer.')
param adminUsername1 string = 'webadmin'



@description('name vnet ManagementServer')
param vnet1Name string = 'Management-prod-vnet'

@description('name vnet WebServer')
param vnet2Name string = 'App-prod-vnet'

var vnet1Config = {
  addressSpacePrefix: '10.10.10.0/24'
  subnetName: 'subnet1'
  subnetPrefix: '10.10.10.0/24'
}

var vnet2Config = {
  addressSpacePrefix: '10.20.20.0/24'
  subnetName1: 'subnet2'
  subnetPrefix: '10.20.20.0/24'
}

var backupFabric = 'Azure'
var protec_container_app_linux = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vmName1}'
var protec_Item_app_linux = 'vm;iaasvmcontainerv2;${resourceGroup().name};${vmName1}'
var protec_container_admin_win = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vmName}'
var protec_Item_admin_windows = 'vm;iaasvmcontainerv2;${resourceGroup().name};${vmName}'

var script64 = loadFileAsBase64('./scripts/webserver.sh') 
param store_name string = 'stvm${uniqueString(resourceGroup().id)}'
param utcValue string = utcNow()
param apachefile string = 'zscript.sh'
//param pubkey string = ''
param pubkey string = loadTextContent('./keys/keylin')


var skuName = 'RS0'
var skuTier = 'Standard'
var nicName1 = 'ManagementVMNic'
var networkSecurityGroupName = 'Management-NSG'
var networkSecurityGroupName1 = 'App-NSG'
var networkInterfaceName = '${vmName1}VMNic'



resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${MAN_ID.id}': {}
    }
  }
  sku:{
    name: 'Standard_LRS'
  } 
  properties: {
    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: false
    allowBlobPublicAccess: false
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    largeFileSharesState: 'Disabled'
    allowSharedKeyAccess: true
    encryption: {
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
         keyname:KEY.name
         keyvaulturi: keyvault.properties.vaultUri
      }
      services: {
        blob: {
          enabled: true
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
      days: 30
      enabled: true
    }
    changeFeed: {
      enabled: false
    }
    automaticSnapshotPolicyEnabled: true
    isVersioningEnabled: true
    restorePolicy: {
      enabled: true
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

resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: vaultName
  location: location
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableSoftDelete: true
    //enablePurgeProtection: false // changed from true
    softDeleteRetentionInDays: 7
    tenantId: tenant
    accessPolicies: [
      {
        tenantId: tenant
        objectId: '9346c2ae-a148-4d97-b928-1aa7a575c37e'
        permissions: {
          keys: [
            'backup'
            'create'
            'delete'
            'get'
            'import'
            'list'
            'recover'
            'restore'
            'getrotationpolicy'
            'setrotationpolicy'
            'rotate'
            

          ]
          secrets: [
            'list'
            'set'
            'get'
            'delete'
            'backup'
            'restore'
            'recover'

          ]
          certificates: [
            'get'
            'backup'
            'create'
            'delete'
            'recover'
            'restore'
            'list'
            'managecontacts'
            'manageissuers'
            'import'
            'update'
            'listissuers'
            'getissuers'
            'setissuers'
            'deleteissuers'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource MAN_ID 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'ManID'
  location: location
  dependsOn: [
    keyvault
  ]
}

resource ACCES_POL 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01' = { 
  name:  'add'
  parent: keyvault
  properties: {
    accessPolicies:[
      {
        tenantId: tenant    //'de60b253-74bd-4365-b598-b9e55a2b208d'
        objectId: DISK_ENCRYPT_SET.identity.principalId
        permissions: {
          keys: [
            'get'
            'wrapKey'
            'unwrapKey'
          ]
          secrets: []
          certificates: []
        }
        
      }
      {
        tenantId: tenant    //'de60b253-74bd-4365-b598-b9e55a2b208d'
        objectId: MAN_ID.properties.principalId
        permissions: {
          keys: [
            'get'
            'list'
            'unwrapKey'
            'wrapKey'
          ]
          secrets: []
          certificates: []
        }
      }
    ]
  }
}

resource KEY 'Microsoft.KeyVault/vaults/keys@2021-11-01-preview' = {
  name: 'RSAkey' // '${keyvault.name}/${keyName}'
  parent: keyvault
  properties: {
    keyOps: [
      'decrypt'
      'encrypt'
      'unwrapKey'
      'wrapKey'
      'sign'
      'verify'
    ]
    attributes: {
      enabled: true
    }
    keySize: 2048
    kty:'RSA'
  }
}

/*resource SECRET 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: keyvault //'${keyvault.name}/${secretName}'
  name: 'ssh'
  properties: {
    value: loadTextContent('../keys/SSH_KEY_RSA')
  }
}*/

output proxKey object = KEY

resource recoverServicesVault 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
  name: vaultName1
  location: location
  sku: {
    name: skuName
    tier: skuTier 
  }
  properties: {}
}

resource vaultName_vaultstorageconfig 'Microsoft.RecoveryServices/vaults/backupconfig@2021-12-01' = {
  parent: recoverServicesVault
  name: 'vaultconfig'
  properties: {
    storageModelType: vaultStorageType
  }
}



resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-12-01' = {
  location: location
  parent: recoverServicesVault 
  name:  policyName  //'back_policy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2022-03-03T04:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
     }
     retentionPolicy: {
       retentionPolicyType: 'LongTermRetentionPolicy'
       dailySchedule: {
         retentionTimes: [
           '2022-03-03T04:00:00Z'
         ]
         retentionDuration: {
           count: 7
           durationType: 'Days'
         }
       }
     }
     instantRpRetentionRangeInDays: 2
     timeZone: 'W. Europe Standard Time'
   }
 }
 
 resource PROTEC_VM_WEB 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
   name: '${'recoveryvault'}/${backupFabric}/${protec_container_app_linux}/${protec_Item_app_linux }'
   properties: {
     protectedItemType: 'Microsoft.Compute/virtualMachines'
     policyId: backupPolicy.id
     sourceResourceId: vmlinux.id       //vmlinux.id
   }
 } 
 
resource PROTEC_VM_ADMIN 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
   name: '${'recoveryvault'}/${backupFabric}/${protec_container_admin_win}/${protec_Item_admin_windows}' 
   properties: {
     protectedItemType: 'Microsoft.Compute/virtualMachines'
     policyId: backupPolicy.id
     sourceResourceId: vmWindows.id     //VM_ADMIN_WIN.id
   }
 } 
  
resource DEPLOY_SCRIPT 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
   name: 'deployscript-upload-blob-${utcValue}'
   location: location
   kind: 'AzureCLI'
   properties: {
     azCliVersion: '2.26.1'
     timeout: 'PT5M'
     retentionInterval: 'PT1H'
     environmentVariables: [
       {
         name: 'AZURE_STORAGE_ACCOUNT'
         value: store_name
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

resource DISK_ENCRYPT_SET 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {  
  name: DISKencryptionsetname
  location:location
  identity: {
    type:'SystemAssigned'
  }
  properties: {
    rotationToLatestKeyVersionEnabled: true
    activeKey: {
      sourceVault: {
        id: keyvault.id
      }
      keyUrl: KEY.properties.keyUriWithVersion
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    }
}

 
resource managementvnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnet1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet1Config.subnetName
        properties: {
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          addressPrefix: vnet1Config.subnetPrefix
          networkSecurityGroup: { 
            id: securityGroup.id
            // properties: {
            //   securityRules: [
            //     {
            //       properties: {
            //         direction: 'Inbound'
            //         protocol: '*'
            //         access: 'Allow'
            //       }
            //     }
            //     {
            //       properties: {
            //         direction: 'Outbound'
            //         protocol: '*'
            //         access: 'Allow'
            //       }
            //     }
            //   ]
            // }
          }
        }
      }
    ]
  }
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: managementvnet
  name:  '${vnet1Name}-${vnet2Name}'
  properties:{
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: Appvnet.id
    }
  }
}

resource Appvnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnet2Name
  location: location
  properties: {
      addressSpace: {
      addressPrefixes: [
        vnet2Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet2Config.subnetName1
        properties: {
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          addressPrefix: vnet2Config.subnetPrefix
          networkSecurityGroup: {
            id: nsg.id
            // properties: {
            //   securityRules: [
            //     {
            //       properties: {
            //         direction: 'Inbound'
            //         protocol: '*'
            //         access: 'Allow'
            //       }
            //     }
            //     {
            //       properties: {
            //         direction: 'Outbound'
            //         protocol: '*'
            //         access: 'Allow'
            //       }
            //     }
            //   ]
            // }
          }
        }
      }
    ]
  }
}

resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: Appvnet
  name: '${vnet2Name}-${vnet1Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: managementvnet.id
    }
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  zones: [
    '2'
  ]
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: networkSecurityGroupName 
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties:{
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          destinationPortRanges:[
            '3389'
            '22'
          ]
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: nicName1
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
        privateIPAllocationMethod: 'Dynamic'
        publicIPAddress: {
          id: pip.id
        }
        subnet: {
          id: managementvnet.properties.subnets[0].id // managementvnet.properties.subnets[0].id // change back to managementvnet.id if needed
        }
      }
     }
    ]
    networkSecurityGroup: {
      id: securityGroup.id
    }
  }
}

resource vmWindows 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  zones: [
    '2'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      secrets: []
      allowExtensionOperations: true
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_ZRS' // change
          diskEncryptionSet: {
            id: DISK_ENCRYPT_SET.id
          }
          }
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageaccount.properties.primaryEndpoints.blob
      }
    }
  }
}


output hostname string = pip.properties.dnsSettings.fqdn

resource niclinux 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: Appvnet.properties.subnets[0].id  //Appvnet.properties.subnets[0].id // change back to appvnet.id if needed
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: piplinux.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName1
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '443'
          ]
        }
      }
    ]
  }
}

resource piplinux 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIpName1
  location: location
  sku: {
    name: publicIpSku
  }
  zones: [
    '2'
  ]
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix1
    }
  }
}

resource vmlinux 'Microsoft.Compute/virtualMachines@2021-11-01' = { 
  name: vmName1
  location: location
  zones: [
    '2'
  ]
  properties: { 
    userData: script64
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer:  '0001-com-ubuntu-server-focal'                    //'0001-com-ubuntu-server-impish'
        sku:   ubuntuOSVersion             //'21_10-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        createOption: 'FromImage'
        managedDisk: {
          diskEncryptionSet: {
            id: DISK_ENCRYPT_SET.id
          }
          storageAccountType:'StandardSSD_ZRS'
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vmName1
      adminUsername: adminUsername1
      adminPassword: null
      linuxConfiguration: {
        ssh: {
          publicKeys: [
            {
              keyData: pubkey
              path: '/home${vmName1}/.ssh/authorized_keys'    //'/home/LinuxVMuser/.ssh/authorized_keys'     '/home${vm_linux}/.ssh/authorized_keys'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niclinux.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

output adminUsername string = adminUsername1
output hostnamelinux string = piplinux.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${adminUsername1}@${piplinux.properties.dnsSettings.fqdn}'
