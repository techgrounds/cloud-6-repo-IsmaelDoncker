param location string = resourceGroup().location
@minLength(3)
@maxLength(24)
param storageAccountName string = toLower('storacc${uniqueString(resourceGroup().id)}')
@description('Blob encryption at Rest')
param blobEncryptionEnabled bool = true
/*param vaultName1 string = 'recovery${uniqueString(resourceGroup().id)}'*/
/*param vaultName string = 'keyVault${uniqueString(resourceGroup().id)}'
/*param sku string = 'Standard'
/*param tenant string = 'de60b253-74bd-4365-b598-b9e55a2b208d' // replace with your tenantId
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
]
@description('Specifies whether ARM is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true
param enabledForDeployment bool = true
param enableRbacAuthorization bool = false
param softDeleteRetentionInDays int = 90  // replace number # change number just a place holder !!!!

/*param keyName string = 'prodKey'
@secure()
param secretName string ='' 

@secure()
param secretValue string = ''
*/

/*param networkAcls object = {
  ipRules: []
  virtualNetworkRules: []
}*/

/*@description('Change Vault Storage Type()')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('name of backup policy')
param policyName string = 'mypolicy${uniqueString(resourceGroup().id)}'

@description('Number of days Instant Recovery Point should be retained')
@allowed([
  7
])
param instantRpRetentionRangeInDays int = 7*/


@description('The name of Management Server')
param adminUsername string 

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
param adminUsername1 string

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'sshPublicKey'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

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

/*var skuName = 'RS0'
var skuTier = 'Standard'*/
var nicName1 = 'ManagementVMNic'
var networkSecurityGroupName = 'Management-NSG'
var networkSecurityGroupName1 = 'App-NSG'
var osDiskType = 'StandardSSD_LRS'
var networkInterfaceName = '${vmName1}VMNic'
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername1}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}


resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01'= {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties:{
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
      encryption: {
        keySource:'Microsoft.Storage'  // change to keyvault
      services:{
        blob: {
          enabled: blobEncryptionEnabled
        }
      }
    }
    }
}


/*resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: vaultName
  location:location
  properties: {
    tenantId: tenant
    sku:{
      family: 'A'
      name: sku
    }
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    networkAcls: networkAcls
  }
}

resource key 'Microsoft.KeyVault/vaults/keys@2021-11-01-preview' = {
  name: '${keyvault.name}/${keyName}'
  properties: {
    kty: 'RSA'
    keyOps: [
      'decrypt'
      'encrypt'
      'wrapKey'
      'unwrapKey'
      'verify'
      'import'
      'sign'
      'release'
    ]
    keySize: 4096
  }
}


resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview'= {
  name: '${keyvault.name}/${secretName}'
  properties: {
    value: secretValue
  }
}

output proxKey object = key */

/*resource recoverServicesVault 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
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
  parent: recoverServicesVault
  name: policyName
  location: location
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: instantRpRetentionRangeInDays
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
    }
    
  }
}*/
 
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
          id: managementvnet.properties.subnets[0].id  // change back to managementvnet.id if needed
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
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
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
        }
      }
      dataDisks: [
        {
          diskSizeGB: 100 // change 
          lun: 0
          createOption: 'Empty'
        }
      ]
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
            id: Appvnet.properties.subnets[0].id // change back to appvnet.id if needed
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
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix1
    }
  }
}

resource vmlinux 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName1
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
        storageAccountType: osDiskType
        }
      }
    
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: ubuntuOSVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niclinux.id
        }
      ]
    }
    osProfile: {
      computerName: vmName1
      adminUsername: adminUsername1
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
  }
}

output adminUsername string = adminUsername1
output hostnamelinux string = piplinux.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${adminUsername1}@${piplinux.properties.dnsSettings.fqdn}'
