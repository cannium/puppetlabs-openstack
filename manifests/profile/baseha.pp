# The base profile for OpenStack. Installs the repository and ntp
class havana::profile::baseha {
  # everyone also needs to be on the same clock
  class { '::ntp': 
      servers   => hiera('ntp::servers'),
  }

  # all nodes need the OpenStack repository
  class { '::havana::resources::repo': }

  # database connectors
  class { '::havana::resources::connectorsha': }

  $api_network = hiera('openstack::network::api')
  $api_address = ip_for_network($api_network)
}
