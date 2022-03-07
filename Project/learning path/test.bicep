

resource symbolicname 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  sku: {
    name: 'string'
  }
  kind: 'string'
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  identity: {
    type: 'string'
    userAssignedIdentities: {}
  }
  properties: {
    accessTier: 'string'
    allowBlobPublicAccess: bool
    allowCrossTenantReplication: bool
    allowedCopyScope: 'string'
    allowSharedKeyAccess: bool
    azureFilesIdentityBasedAuthentication: {
      activeDirectoryProperties: {
        accountType: 'string'
        azureStorageSid: 'string'
        domainGuid: 'string'
        domainName: 'string'
        domainSid: 'string'
        forestName: 'string'
        netBiosDomainName: 'string'
        samAccountName: 'string'
      }
      defaultSharePermission: 'string'
      directoryServiceOptions: 'string'
    }
    customDomain: {
      name: 'string'
      useSubDomainName: bool
    }
    defaultToOAuthAuthentication: bool
    encryption: {
      identity: {
        federatedIdentityClientId: 'string'
        userAssignedIdentity: 'string'
      }
      keySource: 'string'
      keyvaultproperties: {
        keyname: 'string'
        keyvaulturi: 'string'
        keyversion: 'string'
      }
      requireInfrastructureEncryption: bool
      services: {
        blob: {
          enabled: bool
          keyType: 'string'
        }
        file: {
          enabled: bool
          keyType: 'string'
        }
        queue: {
          enabled: bool
          keyType: 'string'
        }
        table: {
          enabled: bool
          keyType: 'string'
        }
      }
    }
    immutableStorageWithVersioning: {
      enabled: bool
      immutabilityPolicy: {
        allowProtectedAppendWrites: bool
        immutabilityPeriodSinceCreationInDays: int
        state: 'string'
      }
    }
    isHnsEnabled: bool
    isLocalUserEnabled: bool
    isNfsV3Enabled: bool
    isSftpEnabled: bool
    keyPolicy: {
      keyExpirationPeriodInDays: int
    }
    largeFileSharesState: 'string'
    minimumTlsVersion: 'string'
    networkAcls: {
      bypass: 'string'
      defaultAction: 'string'
      ipRules: [
        {
          action: 'Allow'
          value: 'string'
        }
      ]
      resourceAccessRules: [
        {
          resourceId: 'string'
          tenantId: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: 'string'
          state: 'string'
        }
      ]
    }
    publicNetworkAccess: 'string'
    routingPreference: {
      publishInternetEndpoints: bool
      publishMicrosoftEndpoints: bool
      routingChoice: 'string'
    }
    sasPolicy: {
      expirationAction: 'Log'
      sasExpirationPeriod: 'string'
    }
    supportsHttpsTrafficOnly: bool
  }
}

resource symbolicname 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    accessPolicies: [
      {
        applicationId: 'string'
        objectId: 'string'
        permissions: {
          certificates: [
            'string'
          ]
          keys: [
            'string'
          ]
          secrets: [
            'string'
          ]
          storage: [
            'string'
          ]
        }
        tenantId: 'string'
      }
    ]
    createMode: 'string'
    enabledForDeployment: bool
    enabledForDiskEncryption: bool
    enabledForTemplateDeployment: bool
    enablePurgeProtection: bool
    enableRbacAuthorization: bool
    enableSoftDelete: bool
    networkAcls: {
      bypass: 'string'
      defaultAction: 'string'
      ipRules: [
        {
          value: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          id: 'string'
          ignoreMissingVnetServiceEndpoint: bool
        }
      ]
    }
    provisioningState: 'string'
    publicNetworkAccess: 'string'
    sku: {
      family: 'A'
      name: 'string'
    }
    softDeleteRetentionInDays: int
    tenantId: 'string'
    vaultUri: 'string'
  }
}

resource symbolicname 'Microsoft.RecoveryServices/vaults@2021-08-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  sku: {
    capacity: 'string'
    family: 'string'
    name: 'string'
    size: 'string'
    tier: 'string'
  }
  etag: 'string'
  identity: {
    type: 'string'
    userAssignedIdentities: {}
  }
  properties: {
    encryption: {
      infrastructureEncryption: 'string'
      kekIdentity: {
        userAssignedIdentity: 'string'
        useSystemAssignedIdentity: bool
      }
      keyVaultProperties: {
        keyUri: 'string'
      }
    }
    moveDetails: {}
    upgradeDetails: {}
  }
}

resource symbolicname 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    securityRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          access: 'string'
          description: 'string'
          destinationAddressPrefix: 'string'
          destinationAddressPrefixes: [
            'string'
          ]
          destinationApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {
                custom-tag-object
              }
            }
          ]
          destinationPortRange: 'string'
          destinationPortRanges: [
            'string'
          ]
          direction: 'string'
          priority: int
          protocol: 'string'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'string'
          ]
          sourceApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {
                custom-tag-object
              }
            }
          ]
          sourcePortRange: 'string'
          sourcePortRanges: [
            'string'
          ]
        }
        type: 'string'
      }
    ]
  }
}
resource symbolicname 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        'string'
      ]
    }
    bgpCommunities: {
      virtualNetworkCommunity: 'string'
    }
    ddosProtectionPlan: {
      id: 'string'
    }
    dhcpOptions: {
      dnsServers: [
        'string'
      ]
    }
    enableDdosProtection: bool
    enableVmProtection: bool
    encryption: {
      enabled: bool
      enforcement: 'string'
    }
    flowTimeoutInMinutes: int
    ipAllocations: [
      {
        id: 'string'
      }
    ]
    subnets: [
      {
        id: 'string'
        name: 'string'
        properties: {
          addressPrefix: 'string'
          addressPrefixes: [
            'string'
          ]
          applicationGatewayIpConfigurations: [
            {
              id: 'string'
              name: 'string'
              properties: {
                subnet: {
                  id: 'string'
                }
              }
            }
          ]
          delegations: [
            {
              id: 'string'
              name: 'string'
              properties: {
                serviceName: 'string'
              }
              type: 'string'
            }
          ]
          ipAllocations: [
            {
              id: 'string'
            }
          ]
          natGateway: {
            id: 'string'
          }
          networkSecurityGroup: {
            id: 'string'
            location: 'string'
            properties: {
              securityRules: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    access: 'string'
                    description: 'string'
                    destinationAddressPrefix: 'string'
                    destinationAddressPrefixes: [
                      'string'
                    ]
                    destinationApplicationSecurityGroups: [
                      {
                        id: 'string'
                        location: 'string'
                        properties: {}
                        tags: {}
                      }
                    ]
                    destinationPortRange: 'string'
                    destinationPortRanges: [
                      'string'
                    ]
                    direction: 'string'
                    priority: int
                    protocol: 'string'
                    sourceAddressPrefix: 'string'
                    sourceAddressPrefixes: [
                      'string'
                    ]
                    sourceApplicationSecurityGroups: [
                      {
                        id: 'string'
                        location: 'string'
                        properties: {}
                        tags: {}
                      }
                    ]
                    sourcePortRange: 'string'
                    sourcePortRanges: [
                      'string'
                    ]
                  }
                  type: 'string'
                }
              ]
            }
            tags: {}
          }
          privateEndpointNetworkPolicies: 'string'
          privateLinkServiceNetworkPolicies: 'string'
          routeTable: {
            id: 'string'
            location: 'string'
            properties: {
              disableBgpRoutePropagation: bool
              routes: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    addressPrefix: 'string'
                    hasBgpOverride: bool
                    nextHopIpAddress: 'string'
                    nextHopType: 'string'
                  }
                  type: 'string'
                }
              ]
            }
            tags: {}
          }
          serviceEndpointPolicies: [
            {
              id: 'string'
              location: 'string'
              properties: {
                contextualServiceEndpointPolicies: [
                  'string'
                ]
                serviceAlias: 'string'
                serviceEndpointPolicyDefinitions: [
                  {
                    id: 'string'
                    name: 'string'
                    properties: {
                      description: 'string'
                      service: 'string'
                      serviceResources: [
                        'string'
                      ]
                    }
                    type: 'string'
                  }
                ]
              }
              tags: {}
            }
          ]
          serviceEndpoints: [
            {
              locations: [
                'string'
              ]
              service: 'string'
            }
          ]
        }
        type: 'string'
      }
    ]
    virtualNetworkPeerings: [
      {
        id: 'string'
        name: 'string'
        properties: {
          allowForwardedTraffic: bool
          allowGatewayTransit: bool
          allowVirtualNetworkAccess: bool
          doNotVerifyRemoteGateways: bool
          peeringState: 'string'
          peeringSyncLevel: 'string'
          remoteAddressSpace: {
            addressPrefixes: [
              'string'
            ]
          }
          remoteBgpCommunities: {
            virtualNetworkCommunity: 'string'
          }
          remoteVirtualNetwork: {
            id: 'string'
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              'string'
            ]
          }
          useRemoteGateways: bool
        }
        type: 'string'
      }
    ]
  }
}
resource symbolicname 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  sku: {
    name: 'string'
    tier: 'string'
  }
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  properties: {
    ddosSettings: {
      ddosCustomPolicy: {
        id: 'string'
      }
      protectedIP: bool
      protectionCoverage: 'string'
    }
    deleteOption: 'string'
    dnsSettings: {
      domainNameLabel: 'string'
      fqdn: 'string'
      reverseFqdn: 'string'
    }
    idleTimeoutInMinutes: int
    ipAddress: 'string'
    ipTags: [
      {
        ipTagType: 'string'
        tag: 'string'
      }
    ]
    linkedPublicIPAddress: {
      public-ip-address-object
    }
      extendedLocation: {
        name: 'string'
        type: 'EdgeZone'
      }
      id: 'string'
      location: 'string'
      properties: {
      sku: {
        name: 'string'
        tier: 'string'
      }
      tags: {}
      zones: [
        'string'
      ]
    }
    migrationPhase: 'string'
    natGateway: {
      id: 'string'
      location: 'string'
      properties: {
        idleTimeoutInMinutes: int
        publicIpAddresses: [
          {
            id: 'string'
          }
        ]
        publicIpPrefixes: [
          {
            id: 'string'
          }
        ]
      }
      sku: {
        name: 'Standard'
      }
      tags: {}
      zones: [
        'string'
      ]
    }
    publicIPAddressVersion: 'string'
    publicIPAllocationMethod: 'string'
    publicIPPrefix: {
      id: 'string'
    }
    servicePublicIPAddress: {
      public-ip-address-object
    }
      extendedLocation: {
        name: 'string'
        type: 'EdgeZone'
      }
      id: 'string'
      location: 'string'
      properties: {
      sku: {
        name: 'string'
        tier: 'string'
      }
      tags: {}
      zones: [
        'string'
      ]
    }
  }
  zones: [
    'string'
  ]
}
resource symbolicname 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  identity: {
    type: 'string'
    userAssignedIdentities: {}
  }
  plan: {
    name: 'string'
    product: 'string'
    promotionCode: 'string'
    publisher: 'string'
  }
  properties: {
    additionalCapabilities: {
      hibernationEnabled: bool
      ultraSSDEnabled: bool
    }
    applicationProfile: {
      galleryApplications: [
        {
          configurationReference: 'string'
          order: int
          packageReferenceId: 'string'
          tags: 'string'
        }
      ]
    }
    availabilitySet: {
      id: 'string'
    }
    billingProfile: {
      maxPrice: int
    }
    capacityReservation: {
      capacityReservationGroup: {
        id: 'string'
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: bool
        storageUri: 'string'
      }
    }
    evictionPolicy: 'string'
    extensionsTimeBudget: 'string'
    hardwareProfile: {
      vmSize: 'string'
      vmSizeProperties: {
        vCPUsAvailable: int
        vCPUsPerCore: int
      }
    }
    host: {
      id: 'string'
    }
    hostGroup: {
      id: 'string'
    }
    licenseType: 'string'
    networkProfile: {
      networkApiVersion: '2020-11-01'
      networkInterfaceConfigurations: [
        {
          name: 'string'
          properties: {
            deleteOption: 'string'
            dnsSettings: {
              dnsServers: [
                'string'
              ]
            }
            dscpConfiguration: {
              id: 'string'
            }
            enableAcceleratedNetworking: bool
            enableFpga: bool
            enableIPForwarding: bool
            ipConfigurations: [
              {
                name: 'string'
                properties: {
                  applicationGatewayBackendAddressPools: [
                    {
                      id: 'string'
                    }
                  ]
                  applicationSecurityGroups: [
                    {
                      id: 'string'
                    }
                  ]
                  loadBalancerBackendAddressPools: [
                    {
                      id: 'string'
                    }
                  ]
                  primary: bool
                  privateIPAddressVersion: 'string'
                  publicIPAddressConfiguration: {
                    name: 'string'
                    properties: {
                      deleteOption: 'string'
                      dnsSettings: {
                        domainNameLabel: 'string'
                      }
                      idleTimeoutInMinutes: int
                      ipTags: [
                        {
                          ipTagType: 'string'
                          tag: 'string'
                        }
                      ]
                      publicIPAddressVersion: 'string'
                      publicIPAllocationMethod: 'string'
                      publicIPPrefix: {
                        id: 'string'
                      }
                    }
                    sku: {
                      name: 'string'
                      tier: 'string'
                    }
                  }
                  subnet: {
                    id: 'string'
                  }
                }
              }
            ]
            networkSecurityGroup: {
              id: 'string'
            }
            primary: bool
          }
        }
      ]
      networkInterfaces: [
        {
          id: 'string'
          properties: {
            deleteOption: 'string'
            primary: bool
          }
        }
      ]
    }
    osProfile: {
      adminPassword: 'string'
      adminUsername: 'string'
      allowExtensionOperations: bool
      computerName: 'string'
      customData: 'string'
      linuxConfiguration: {
        disablePasswordAuthentication: bool
        patchSettings: {
          assessmentMode: 'string'
          patchMode: 'string'
        }
        provisionVMAgent: bool
        ssh: {
          publicKeys: [
            {
              keyData: 'string'
              path: 'string'
            }
          ]
        }
      }
      requireGuestProvisionSignal: bool
      secrets: [
        {
          sourceVault: {
            id: 'string'
          }
          vaultCertificates: [
            {
              certificateStore: 'string'
              certificateUrl: 'string'
            }
          ]
        }
      ]
      windowsConfiguration: {
        additionalUnattendContent: [
          {
            componentName: 'Microsoft-Windows-Shell-Setup'
            content: 'string'
            passName: 'OobeSystem'
            settingName: 'string'
          }
        ]
        enableAutomaticUpdates: bool
        patchSettings: {
          assessmentMode: 'string'
          enableHotpatching: bool
          patchMode: 'string'
        }
        provisionVMAgent: bool
        timeZone: 'string'
        winRM: {
          listeners: [
            {
              certificateUrl: 'string'
              protocol: 'string'
            }
          ]
        }
      }
    }
    platformFaultDomain: int
    priority: 'string'
    proximityPlacementGroup: {
      id: 'string'
    }
    scheduledEventsProfile: {
      terminateNotificationProfile: {
        enable: bool
        notBeforeTimeout: 'string'
      }
    }
    securityProfile: {
      encryptionAtHost: bool
      securityType: 'string'
      uefiSettings: {
        secureBootEnabled: bool
        vTpmEnabled: bool
      }
    }
    storageProfile: {
      dataDisks: [
        {
          createOption: 'string'
          deleteOption: 'string'
          detachOption: 'ForceDetach'
          diskSizeGB: int
          image: {
            uri: 'string'
          }
          lun: int
          managedDisk: {
            diskEncryptionSet: {
              id: 'string'
            }
            id: 'string'
            securityProfile: {
              diskEncryptionSet: {
                id: 'string'
              }
              securityEncryptionType: 'string'
            }
            storageAccountType: 'string'
          }
          name: 'string'
          toBeDetached: bool
          vhd: {
            uri: 'string'
          }
          writeAcceleratorEnabled: bool
        }
      ]
      imageReference: {
        communityGalleryImageId: 'string'
        id: 'string'
        offer: 'string'
        publisher: 'string'
        sharedGalleryImageId: 'string'
        sku: 'string'
        version: 'string'
      }
      osDisk: {
        createOption: 'string'
        deleteOption: 'string'
        diffDiskSettings: {
          option: 'Local'
          placement: 'string'
        }
        diskSizeGB: int
        encryptionSettings: {
          diskEncryptionKey: {
            secretUrl: 'string'
            sourceVault: {
              id: 'string'
            }
          }
          enabled: bool
          keyEncryptionKey: {
            keyUrl: 'string'
            sourceVault: {
              id: 'string'
            }
          }
        }
        image: {
          uri: 'string'
        }
        managedDisk: {
          diskEncryptionSet: {
            id: 'string'
          }
          id: 'string'
          securityProfile: {
            diskEncryptionSet: {
              id: 'string'
            }
            securityEncryptionType: 'string'
          }
          storageAccountType: 'string'
        }
        name: 'string'
        osType: 'string'
        vhd: {
          uri: 'string'
        }
        writeAcceleratorEnabled: bool
      }
    }
    userData: 'string'
    virtualMachineScaleSet: {
      id: 'string'
    }
  }
  zones: [
    'string'
  ]
}

resource symbolicname 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  name: 'string'
  parent: resourceSymbolicName
  properties: {
    allowForwardedTraffic: bool
    allowGatewayTransit: bool
    allowVirtualNetworkAccess: bool
    doNotVerifyRemoteGateways: bool
    peeringState: 'string'
    peeringSyncLevel: 'string'
    remoteAddressSpace: {
      addressPrefixes: [
        'string'
      ]
    }
    remoteBgpCommunities: {
      virtualNetworkCommunity: 'string'
    }
    remoteVirtualNetwork: {
      id: 'string'
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        'string'
      ]
    }
    useRemoteGateways: bool
  }
}

resource symbolicname 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    securityRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          access: 'string'
          description: 'string'
          destinationAddressPrefix: 'string'
          destinationAddressPrefixes: [
            'string'
          ]
          destinationApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {
                custom-tag-object
              }
            }
          ]
          destinationPortRange: 'string'
          destinationPortRanges: [
            'string'
          ]
          direction: 'string'
          priority: int
          protocol: 'string'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'string'
          ]
          sourceApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {
                custom-tag-object
              }
            }
          ]
          sourcePortRange: 'string'
          sourcePortRanges: [
            'string'
          ]
        }
        type: 'string'
      }
    ]
  }
}
resource symbolicname 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        'string'
      ]
    }
    bgpCommunities: {
      virtualNetworkCommunity: 'string'
    }
    ddosProtectionPlan: {
      id: 'string'
    }
    dhcpOptions: {
      dnsServers: [
        'string'
      ]
    }
    enableDdosProtection: bool
    enableVmProtection: bool
    encryption: {
      enabled: bool
      enforcement: 'string'
    }
    flowTimeoutInMinutes: int
    ipAllocations: [
      {
        id: 'string'
      }
    ]
    subnets: [
      {
        id: 'string'
        name: 'string'
        properties: {
          addressPrefix: 'string'
          addressPrefixes: [
            'string'
          ]
          applicationGatewayIpConfigurations: [
            {
              id: 'string'
              name: 'string'
              properties: {
                subnet: {
                  id: 'string'
                }
              }
            }
          ]
          delegations: [
            {
              id: 'string'
              name: 'string'
              properties: {
                serviceName: 'string'
              }
              type: 'string'
            }
          ]
          ipAllocations: [
            {
              id: 'string'
            }
          ]
          natGateway: {
            id: 'string'
          }
          networkSecurityGroup: {
            id: 'string'
            location: 'string'
            properties: {
              securityRules: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    access: 'string'
                    description: 'string'
                    destinationAddressPrefix: 'string'
                    destinationAddressPrefixes: [
                      'string'
                    ]
                    destinationApplicationSecurityGroups: [
                      {
                        id: 'string'
                        location: 'string'
                        properties: {}
                        tags: {}
                      }
                    ]
                    destinationPortRange: 'string'
                    destinationPortRanges: [
                      'string'
                    ]
                    direction: 'string'
                    priority: int
                    protocol: 'string'
                    sourceAddressPrefix: 'string'
                    sourceAddressPrefixes: [
                      'string'
                    ]
                    sourceApplicationSecurityGroups: [
                      {
                        id: 'string'
                        location: 'string'
                        properties: {}
                        tags: {}
                      }
                    ]
                    sourcePortRange: 'string'
                    sourcePortRanges: [
                      'string'
                    ]
                  }
                  type: 'string'
                }
              ]
            }
            tags: {}
          }
          privateEndpointNetworkPolicies: 'string'
          privateLinkServiceNetworkPolicies: 'string'
          routeTable: {
            id: 'string'
            location: 'string'
            properties: {
              disableBgpRoutePropagation: bool
              routes: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    addressPrefix: 'string'
                    hasBgpOverride: bool
                    nextHopIpAddress: 'string'
                    nextHopType: 'string'
                  }
                  type: 'string'
                }
              ]
            }
            tags: {}
          }
          serviceEndpointPolicies: [
            {
              id: 'string'
              location: 'string'
              properties: {
                contextualServiceEndpointPolicies: [
                  'string'
                ]
                serviceAlias: 'string'
                serviceEndpointPolicyDefinitions: [
                  {
                    id: 'string'
                    name: 'string'
                    properties: {
                      description: 'string'
                      service: 'string'
                      serviceResources: [
                        'string'
                      ]
                    }
                    type: 'string'
                  }
                ]
              }
              tags: {}
            }
          ]
          serviceEndpoints: [
            {
              locations: [
                'string'
              ]
              service: 'string'
            }
          ]
        }
        type: 'string'
      }
    ]
    virtualNetworkPeerings: [
      {
        id: 'string'
        name: 'string'
        properties: {
          allowForwardedTraffic: bool
          allowGatewayTransit: bool
          allowVirtualNetworkAccess: bool
          doNotVerifyRemoteGateways: bool
          peeringState: 'string'
          peeringSyncLevel: 'string'
          remoteAddressSpace: {
            addressPrefixes: [
              'string'
            ]
          }
          remoteBgpCommunities: {
            virtualNetworkCommunity: 'string'
          }
          remoteVirtualNetwork: {
            id: 'string'
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              'string'
            ]
          }
          useRemoteGateways: bool
        }
        type: 'string'
      }
    ]
  }
}

resource symbolicname 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  identity: {
    type: 'string'
    userAssignedIdentities: {}
  }
  plan: {
    name: 'string'
    product: 'string'
    promotionCode: 'string'
    publisher: 'string'
  }
  properties: {
    additionalCapabilities: {
      hibernationEnabled: bool
      ultraSSDEnabled: bool
    }
    applicationProfile: {
      galleryApplications: [
        {
          configurationReference: 'string'
          order: int
          packageReferenceId: 'string'
          tags: 'string'
        }
      ]
    }
    availabilitySet: {
      id: 'string'
    }
    billingProfile: {
      maxPrice: int
    }
    capacityReservation: {
      capacityReservationGroup: {
        id: 'string'
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: bool
        storageUri: 'string'
      }
    }
    evictionPolicy: 'string'
    extensionsTimeBudget: 'string'
    hardwareProfile: {
      vmSize: 'string'
      vmSizeProperties: {
        vCPUsAvailable: int
        vCPUsPerCore: int
      }
    }
    host: {
      id: 'string'
    }
    hostGroup: {
      id: 'string'
    }
    licenseType: 'string'
    networkProfile: {
      networkApiVersion: '2020-11-01'
      networkInterfaceConfigurations: [
        {
          name: 'string'
          properties: {
            deleteOption: 'string'
            dnsSettings: {
              dnsServers: [
                'string'
              ]
            }
            dscpConfiguration: {
              id: 'string'
            }
            enableAcceleratedNetworking: bool
            enableFpga: bool
            enableIPForwarding: bool
            ipConfigurations: [
              {
                name: 'string'
                properties: {
                  applicationGatewayBackendAddressPools: [
                    {
                      id: 'string'
                    }
                  ]
                  applicationSecurityGroups: [
                    {
                      id: 'string'
                    }
                  ]
                  loadBalancerBackendAddressPools: [
                    {
                      id: 'string'
                    }
                  ]
                  primary: bool
                  privateIPAddressVersion: 'string'
                  publicIPAddressConfiguration: {
                    name: 'string'
                    properties: {
                      deleteOption: 'string'
                      dnsSettings: {
                        domainNameLabel: 'string'
                      }
                      idleTimeoutInMinutes: int
                      ipTags: [
                        {
                          ipTagType: 'string'
                          tag: 'string'
                        }
                      ]
                      publicIPAddressVersion: 'string'
                      publicIPAllocationMethod: 'string'
                      publicIPPrefix: {
                        id: 'string'
                      }
                    }
                    sku: {
                      name: 'string'
                      tier: 'string'
                    }
                  }
                  subnet: {
                    id: 'string'
                  }
                }
              }
            ]
            networkSecurityGroup: {
              id: 'string'
            }
            primary: bool
          }
        }
      ]
      networkInterfaces: [
        {
          id: 'string'
          properties: {
            deleteOption: 'string'
            primary: bool
          }
        }
      ]
    }
    osProfile: {
      adminPassword: 'string'
      adminUsername: 'string'
      allowExtensionOperations: bool
      computerName: 'string'
      customData: 'string'
      linuxConfiguration: {
        disablePasswordAuthentication: bool
        patchSettings: {
          assessmentMode: 'string'
          patchMode: 'string'
        }
        provisionVMAgent: bool
        ssh: {
          publicKeys: [
            {
              keyData: 'string'
              path: 'string'
            }
          ]
        }
      }
      requireGuestProvisionSignal: bool
      secrets: [
        {
          sourceVault: {
            id: 'string'
          }
          vaultCertificates: [
            {
              certificateStore: 'string'
              certificateUrl: 'string'
            }
          ]
        }
      ]
      windowsConfiguration: {
        additionalUnattendContent: [
          {
            componentName: 'Microsoft-Windows-Shell-Setup'
            content: 'string'
            passName: 'OobeSystem'
            settingName: 'string'
          }
        ]
        enableAutomaticUpdates: bool
        patchSettings: {
          assessmentMode: 'string'
          enableHotpatching: bool
          patchMode: 'string'
        }
        provisionVMAgent: bool
        timeZone: 'string'
        winRM: {
          listeners: [
            {
              certificateUrl: 'string'
              protocol: 'string'
            }
          ]
        }
      }
    }
    platformFaultDomain: int
    priority: 'string'
    proximityPlacementGroup: {
      id: 'string'
    }
    scheduledEventsProfile: {
      terminateNotificationProfile: {
        enable: bool
        notBeforeTimeout: 'string'
      }
    }
    securityProfile: {
      encryptionAtHost: bool
      securityType: 'string'
      uefiSettings: {
        secureBootEnabled: bool
        vTpmEnabled: bool
      }
    }
    storageProfile: {
      dataDisks: [
        {
          createOption: 'string'
          deleteOption: 'string'
          detachOption: 'ForceDetach'
          diskSizeGB: int
          image: {
            uri: 'string'
          }
          lun: int
          managedDisk: {
            diskEncryptionSet: {
              id: 'string'
            }
            id: 'string'
            securityProfile: {
              diskEncryptionSet: {
                id: 'string'
              }
              securityEncryptionType: 'string'
            }
            storageAccountType: 'string'
          }
          name: 'string'
          toBeDetached: bool
          vhd: {
            uri: 'string'
          }
          writeAcceleratorEnabled: bool
        }
      ]
      imageReference: {
        communityGalleryImageId: 'string'
        id: 'string'
        offer: 'string'
        publisher: 'string'
        sharedGalleryImageId: 'string'
        sku: 'string'
        version: 'string'
      }
      osDisk: {
        createOption: 'string'
        deleteOption: 'string'
        diffDiskSettings: {
          option: 'Local'
          placement: 'string'
        }
        diskSizeGB: int
        encryptionSettings: {
          diskEncryptionKey: {
            secretUrl: 'string'
            sourceVault: {
              id: 'string'
            }
          }
          enabled: bool
          keyEncryptionKey: {
            keyUrl: 'string'
            sourceVault: {
              id: 'string'
            }
          }
        }
        image: {
          uri: 'string'
        }
        managedDisk: {
          diskEncryptionSet: {
            id: 'string'
          }
          id: 'string'
          securityProfile: {
            diskEncryptionSet: {
              id: 'string'
            }
            securityEncryptionType: 'string'
          }
          storageAccountType: 'string'
        }
        name: 'string'
        osType: 'string'
        vhd: {
          uri: 'string'
        }
        writeAcceleratorEnabled: bool
      }
    }
    userData: 'string'
    virtualMachineScaleSet: {
      id: 'string'
    }
  }
  zones: [
    'string'
  ]
}
