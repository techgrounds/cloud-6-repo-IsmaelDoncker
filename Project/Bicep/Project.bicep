param location string = resourceGroup().location
param storageAccountName string
param vaultName string = 'keyVault${uniqueString(resourceGroup().id)}'
param sku string = 'Standard'
param tenant string = '' // replace with your tenantId
param accessPolicies array = [
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

param keyName string = 'prodKey'
@secure()
param secretName string =''
@secure()
param secretValue string = ''

param networkAcls object = {
  ipRules: []
  virtualNetworkRules: []
}

@description('Change Vault Storage Type()')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('name of backup policy')
param policyName string

@description('Number of days Instant Recovery Point should be retained')
@allowed([
  7
])
param instantRpRetentionRangeInDays int = 7


@description('The name of Management Server')
param adminUsername string 

@description('the password for the Management Server')
@minLength(12)
@secure()
param adminPassword string

@description('')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('')
param publicIpName string = 'ManagementPublicIP'

@description('linuxIP')
param publicIpName1 string = 'AppPublicIP'

@description('')
@allowed([
  'Static'
  'Dynamic'
])
param publicIPAllocationMethod string = 'Static'

@description('')
param publicIpSku string = 'Standard'

@description('')
@allowed([
  '2019-Datacenter'
  '2022-Datacenter'
  '20.04-LTS'
])
param OSVersion string = '2019-Datacenter'
param ubuntuOSVersion string = '20.04-LTS'

@description('')
param vmSize string = 'Standard_B2s'

@description('The name of Management Server VM')
param vmName string = 'Management Server'

@description('The name of you Web Server Virtual Machine.')
param vmName1 string = 'Web Server'

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
  subnetName: 'subnet1'
  subnetPrefix: '10.20.20.0/24'
}

var skuName = 'RS0'
var skuTier = 'Standard'
var nicName1 = 'ManagementVMNic'
var networkSecurityGroupName = 'Management-NSG'
var networkSecurityGroupName1 = 'App-NSG'
var osDiskType = 'Standard_LRS'
var networkInterfaceName = '${vmName1}NetInt'
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
    
  }
}



resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
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

output proxKey object = key

resource recoverServicesVault 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
  name: vaultName
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
          addressPrefix: vnet1Config.subnetPrefix
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
        name: vnet2Config.subnetName
        properties: {
          addressPrefix: vnet2Config.subnetPrefix
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
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          destinationPortRange: '3389'
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
        privateIPAllocationMethod: 'Static'
        publicIPAddress: {
          id: pip.id
        }
        subnet: {
          id: managementvnet.id
        }
      }
     }
    ]
    networkSecurityGroup: {
      id: securityGroup.id
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
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
          diskSizeGB: 1023 // change 
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
            id: Appvnet.id
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
          destinationPortRange: '22'
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
      domainNameLabel: dnsLabelPrefix
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
        offer: 'UbuntuServer'
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
