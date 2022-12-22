param virtualNetworks_vnet_webserver_template_name string = 'vnet-webserver-template'
param networkSecurityGroups_security_rules_web_template_name string = 'security-rules-web-template'

resource networkSecurityGroups_security_rules_web_template_name_resource 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: networkSecurityGroups_security_rules_web_template_name
  location: 'westeurope'
  properties: {
    securityRules: [
      {
        name: 'AllowAnyHTTPInbound'
        id: networkSecurityGroups_security_rules_web_template_name_AllowAnyHTTPInbound.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_security_rules_web_template_name_AllowAnyHTTPInbound 'Microsoft.Network/networkSecurityGroups/securityRules@2022-05-01' = {
  name: '${networkSecurityGroups_security_rules_web_template_name}/AllowAnyHTTPInbound'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_security_rules_web_template_name_resource
  ]
}

resource virtualNetworks_vnet_webserver_template_name_resource 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworks_vnet_webserver_template_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.10.0/24'
      ]
    }
    subnets: [
      {
        name: 'snet-webserver-template'
        id: virtualNetworks_vnet_webserver_template_name_snet_webserver_template.id
        properties: {
          addressPrefix: '10.10.10.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_security_rules_web_template_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_webserver_template_name_snet_webserver_template 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = {
  name: '${virtualNetworks_vnet_webserver_template_name}/snet-webserver-template'
  properties: {
    addressPrefix: '10.10.10.0/24'
    networkSecurityGroup: {
      id: networkSecurityGroups_security_rules_web_template_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_webserver_template_name_resource

  ]
}