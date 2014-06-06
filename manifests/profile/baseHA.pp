# The base profile for OpenStack. Installs the repository and ntp
class havana::profile::baseHA {
  # everyone also needs to be on the same clock
  class { '::ntp': }

  # all nodes need the OpenStack repository
  class { '::havana::resources::repo': }

  # database connectors
  class { '::havana::resources::connectorsHA': }

  $management_network = hiera('openstack::network::management')
  $management_address = ip_for_network($management_network)
  if($::hostname == 'controller01') {
      $controller_management_address = hiera('openstack::controller::address::01')
      $storage_management_address = hiera('openstack::storage::address::01')
      $controller_api_address = hiera('openstack::controller::address::01')
      $storage_api_address    = hiera('openstack::storage::address::01')
      $other_node_address = hiera('openstack::controller::address::02')
  } else {
      $controller_management_address = hiera('openstack::controller::address::02')
      $storage_management_address = hiera('openstack::storage::address::02')
      $controller_api_address = hiera('openstack::controller::address::02')
      $storage_api_address    = hiera('openstack::storage::address::02')
      $other_node_address = hiera('openstack::controller::address::01')
  }

  $api_network = hiera('openstack::network::api')
  $api_address = ip_for_network($api_network)
}
