class havana::address {
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
}
