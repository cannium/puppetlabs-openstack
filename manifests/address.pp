class havana::address {
  if($::hostname == 'controller01') {
      $controller_management_address = hiera('openstack::controller::address::01')
      $storage_management_address = hiera('openstack::storage::address::01')
      $controller_api_address = hiera('openstack::controller::address::01')
      $storage_api_address    = hiera('openstack::storage::address::01')
      $other_node_address = hiera('openstack::controller::address::02')
  } elsif ($::hostname == 'controller02') {
      $controller_management_address = hiera('openstack::controller::address::02')
      $storage_management_address = hiera('openstack::storage::address::02')
      $controller_api_address = hiera('openstack::controller::address::02')
      $storage_api_address    = hiera('openstack::storage::address::02')
      $other_node_address = hiera('openstack::controller::address::01')
  } else {
      # compute node
      $controller_management_address = hiera('openstack::controller:address::virtual')
      $storage_management_address = hiera('openstack::controller::address::virtual')
      $controller_api_address = hiera('openstack::controller::address:virtual')
      $storage_api_address = hiera('openstack::controller::address::virtual')
      $other_node_address = hiera('openstack::controller::address::virtual')
  }
}
