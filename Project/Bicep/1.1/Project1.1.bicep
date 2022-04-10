param location string = resourceGroup().location
@minLength(3)
@maxLength(24)
param vaultName1 string = 'recovery${uniqueString(resourceGroup().id)}'
param vaultName string = 'keyVault${uniqueString(resourceGroup().id)}' // change everytime for testing
/* param sku string = 'Standard' */
param tenant string = subscription().tenantId //'de60b253-74bd-4365-b598-b9e55a2b208d' // replace if needed tenantId


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

//@description('gatewayname')
//param appgateway string = 'appgateway1'

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

@description('DNS Appgateway')
param dnsLabelPrefix2 string = toLower('appgateway-${uniqueString(resourceGroup().id)}')

@description('WindowsIp')
param publicIpName string = 'ManagementPublicIP'

@description('linuxIP')
param publicIpName1 string = 'AppPublicIP'

@description('AppGatewayIP')
param publicIPName2 string = 'AppGatewayIP'

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
  '2019-datacenter-gensecond'
  '2022-Datacenter'
  '20_04-lts-gen2'
])
param OSVersion string = '2019-datacenter-gensecond'
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

var vnet3config = {
  addressSpacePrefix: '10.20.20.1/24'
  subnetName3: 'gwsubnet3'
  subnetPrefix: '10.20.20.1/24'
}

var backupFabric = 'Azure'
var protec_container_app_linux = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vmName1}'
var protec_Item_app_linux = 'vm;iaasvmcontainerv2;${resourceGroup().name};${vmName1}'
var protec_container_admin_win = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vmName}'
var protec_Item_admin_windows = 'vm;iaasvmcontainerv2;${resourceGroup().name};${vmName}'

var script64 = loadFileAsBase64('./scripts/webserver.sh') 
param accpol string = 'add'

//param pubkey string = ''
param pubkey string = loadTextContent('./keys/keylin')
//param secret string


var skuName = 'RS0'
var skuTier = 'Standard'
var nicName1 = 'ManagementVMNic'
var networkSecurityGroupName = 'Management-NSG'
var networkSecurityGroupName1 = 'App-NSG'
var networkInterfaceName = '${vmName1}VMNic'


module deploy_one './storacc.bicep' = {
  name: 'ex'
  params: {
    Man_in: MAN_ID.id
    keyurlin: keyvault.properties.vaultUri
    location : location
    kvkey: KEY.name
  }
}



/*resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
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
        userAssignedIdentity: MAN_ID.id // added
      }
      requireInfrastructureEncryption: false // added
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
         keyname: 'RSAkey'         //KEY.name
         keyvaulturi: keyvault.properties.vaultUri
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
}*/


   


resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
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
    enableRbacAuthorization: false
    enableSoftDelete: true
    enablePurgeProtection: true  
    softDeleteRetentionInDays: 7
    tenantId: tenant
    accessPolicies: [
      {
        tenantId: tenant
        //objectId: '28b11e7a-f620-4446-9437-952e456e3bf3' 
        objectId: MAN_ID.properties.principalId  // change
        permissions:{
          keys: [
       //     'backup'
        //    'create'
        //    'delete'
        //    'get'
        //    'import'
       //     'list'
       //     'recover'
        //    'restore'
        //    'getrotationpolicy'
       //     'setrotationpolicy'
       //     'rotate'
            'all'
            

          ]
          secrets: [
        //    'list'
        //    'set'
        //    'get'
         //   'delete'
         //   'backup'
        //    'restore'
       //     'recover'
            'all'

          ]
          certificates: [
        //    'get'
         //   'backup'
         //   'create'
        //    'delete'
         //   'recover'
        //    'restore'
        //    'list'
         //   'managecontacts'
         //   'manageissuers'
         //   'import'
         //   'update'
          //  'listissuers'
          //  'getissuers'
           // 'setissuers'
           // 'deleteissuers'
            'all'
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
  /*dependsOn: [
    keyvault
  ]*/
}

resource ACCES_POL 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01' = { 
  name:  accpol
  parent: keyvault
  properties: {
    accessPolicies:[
      {
        tenantId: tenant    //'de60b253-74bd-4365-b598-b9e55a2b208d'
        objectId:  DISK_ENCRYPT_SET.identity.principalId  
        permissions: {
          keys: [
          //  'get'
          //  'wrapKey'
           // 'unwrapKey'
           // 'list' // delete if needed
           'all'
          ]
        storage: [
          'all'
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
           // 'get'
          //  'list'
          //  'unwrapKey'
         //   'wrapKey'
            'all'
          ]
          storage: [
            'all'
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

resource SECRET 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: keyvault //'${keyvault.name}/${secretName}'
  name: 'winadmin'
  properties: {
    value:  'autogenerated-${uniqueString(deployment().name)}!' // loadTextContent('../keys/SSH_KEY_RSA')
    contentType: 'password for winadmin'
  }
}

output proxKey object = KEY

resource recoverServicesVault 'Microsoft.RecoveryServices/vaults@2022-01-01' = {
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
 
 resource PROTEC_vmLinux 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
   name: '${vaultName1}/${backupFabric}/${protec_container_app_linux}/${protec_Item_app_linux }'
   properties: {
     protectedItemType: 'Microsoft.Compute/virtualMachines'
     policyId: backupPolicy.id
     sourceResourceId: vmlinuxss.id       
   }
 } 
 
 resource PROTEC_vmWindows 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
   name: '${vaultName1}/${backupFabric}/${protec_container_admin_win}/${protec_Item_admin_windows}' 
   properties: {
     protectedItemType: 'Microsoft.Compute/virtualMachines'
     policyId: backupPolicy.id
     sourceResourceId: vmWindows.id     
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
          }
        }
      }
    ]
  }
}

resource appgatesub 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: 'appgatesub'
  parent: Appvnet
  properties: {
    addressPrefix: vnet3config.subnetPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    networkSecurityGroup: {
       id: nsg.id
    }
  }
}

resource natgate 'Microsoft.Network/natGateways@2021-05-01' = {
  name: 'natgatew'
   location: location
   sku: {
     name: 'Standard'
   }
   properties: {
     idleTimeoutInMinutes: 4
      publicIpAddresses: [
        {
          id: piplinux.id // maybe change
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
            '80'
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
      adminPassword: adminPassword // SECRET.properties.value  
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
        //storageUri: deploy_one.outputs.private_out
      }
    }
  }
  dependsOn:[
    keyvault
  ]
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
            '80'
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

resource pipgateway 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIPName2
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
      domainNameLabel: dnsLabelPrefix2
    }
  }

}

resource applicationGateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: 'appgateway'
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 1
    }
    gatewayIPConfigurations: [
      {
        name: 'frontendIp'//'gatewayip'
        properties: {
          subnet: {
            id: appgatesub.id //Appvnet.properties.subnets[0].id //'id'
          }
        }
      }
    ]
    sslCertificates:[
      {
       name: 'mycert' 
       properties: {
         data: loadFileAsBase64('./certs/appcert.pfx')
         password: 'WUNn1mT'
       }
      }
    ]
    authenticationCertificates:[]
    frontendIPConfigurations: [
      {
        name: 'frontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pipgateway.id   //piplinux.id //'id'
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appgatewayfrontendport'
        properties: {
          port: 443 //80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appgatewaybackendpool'
        properties:{
          backendAddresses:[]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'backendsettings'
        properties: {
          port: 80 //443
          protocol: 'Http'//'Https'
          cookieBasedAffinity: 'Disabled'
          connectionDraining:{
            enabled: false
            drainTimeoutInSec: 1
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'appgatewaylistener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations/','appgateway', 'frontendIp')//'id'
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts/', 'appgateway', 'appGatewayFrontendPort')//'id'
          }
          protocol: 'Http'
          sslCertificate: { 
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', 'appgateway', 'mycert')//null add cert
        }
        hostName: null // []
        requireServerNameIndication: false
      }
    }
    {
        name: 'cmListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations/', 'appgateway', 'frontedIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts/', 'appgateway', 'httpPort')
          }
          protocol: 'Http'
          hostNames: []
          requireServerNameIndication: false
        }
      }
    ]
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: 'rule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/', 'appgateway', 'cmListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools/', 'appgateway', 'appgatewaybackendpool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection/', 'appgateway', 'backendsettings')
          }
        }
      }
      {
        name: 'rule2'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/', 'appgateway', 'cmListener')
          }
          redirectConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/redirectConfigurations/', 'appgateway', 'httpToHttps')
          }
        }
      }
    ]
    probes: []
    rewriteRuleSets: []
    redirectConfigurations: [
      {
        name: 'httpToHttps'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners/', 'appgateway', 'cmListener')
          }
          includePath: true
          includeQueryString: true
          requestRoutingRules: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/requestRoutingRules/', 'appgateway', 'rule2')
            }
          ]
        }
      }
    ]
  }
  dependsOn: [
   Appvnet
  ]
}

resource webappAutoScaleSettings 'Microsoft.Insights/autoscalesettings@2021-05-01-preview' = {
  name: 'autoscale-settings'
  location: location
  properties: {
    name: 'name'
    profiles: [
      {
        name: 'set1'
        capacity: {
          minimum: '1'
          maximum: '3'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'name'
              metricResourceUri: vmlinuxss.id //'metricResourceUri'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 80
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value:  '1'
              cooldown: 'PT10M'
            }
          }
          {
            metricTrigger: {
              metricName: 'metricName'
              metricResourceUri: vmlinuxss.id//'metricResourceUri'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 60
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
    enabled: true
    targetResourceUri: vmlinuxss.id   //'targetResourceUri'
  }
}

resource vmlinuxss 'Microsoft.Compute/virtualMachineScaleSets@2021-11-01' = {
  name: vmName1
  location: location
  zones: [
    '2'
  ]
  sku: {
    capacity: 1
    name: vmSize
    tier: 'Standard'
  }
  properties:{
    singlePlacementGroup: false
    orchestrationMode: 'Flexible'
    virtualMachineProfile:{
    userData: script64
    hardwareProfile: {
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer:  '0001-com-ubuntu-server-focal'                    
        sku:   ubuntuOSVersion            
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
      }
      dataDisks: []
    }
    osProfile: {
      adminUsername: adminUsername1
      adminPassword: null
      linuxConfiguration: {
        ssh: {
          publicKeys: [
            {
              keyData: pubkey
              path: '/home/webadmin/.ssh/authorized_keys'    //  '/home${vm_linux}/.ssh/authorized_keys'
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
    extensionProfile: {
      extensions: [
        {
          name: 'HealthExtension'
          properties: {
            autoUpgradeMinorVersion: false
            publisher: 'Microsoft.ManagedServices'
            type: 'ApplicationHealthLinux'
            typeHandlerVersion: '1.0'
            settings: {
              protocol: 'http'
              port: 80
              requestPath: '/'
            }
          }
        }
      ]
    }
    networkProfile: {
     networkApiVersion: '2020-11-01'
     networkInterfaceConfigurations: [
       {
         name: '${vmName1}niclinux'
          properties:{
            primary: true
              enableAcceleratedNetworking: false
              enableIPForwarding: false
            ipConfigurations: [
              {
                name: '${vmName1}Ipconfig'
                properties:{
                  subnet:{
                    id: Appvnet.properties.subnets[0].id
                  }
                privateIPAddressVersion: 'IPv4'
                applicationGatewayBackendAddressPools: [
                {
                  id: applicationGateway.properties.backendAddressPools[0].id
                }
              ]  
            }
              }
          
        ]
        networkSecurityGroup: {
          id: nsg.id
          }
       }
    }
     ]
    }
  }

    platformFaultDomainCount: 1
    automaticRepairsPolicy: {
      enabled: true
      repairAction:'Reimage'
      gracePeriod: 'PT45'
    }
  }
}


output adminUsername string = adminUsername1
output hostnamelinux string = piplinux.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${adminUsername1}@${piplinux.properties.dnsSettings.fqdn}'
