class havana::address {
  $hostname01 = hiera('openstack::controller::hostname::01')
  $hostname02 = hiera('openstack::controller::hostname::02')
  if($::hostname == $hostname01) {
      $controller_management_address = hiera('openstack::controller::address::01')
      $storage_management_address = hiera('openstack::storage::address::01')
      $controller_api_address = hiera('openstack::controller::address::01')
      $storage_api_address    = hiera('openstack::storage::address::01')
      $other_node_address = hiera('openstack::controller::address::02')
  } elsif ($::hostname == $hostname02) {
      $controller_management_address = hiera('openstack::controller::address::02')
      $storage_management_address = hiera('openstack::storage::address::02')
      $controller_api_address = hiera('openstack::controller::address::02')
      $storage_api_address    = hiera('openstack::storage::address::02')
      $other_node_address = hiera('openstack::controller::address::01')
  } else {
      # compute node
      $controller_management_address = hiera('openstack::controller::address::virtual')
      $storage_management_address = hiera('openstack::controller::address::virtual')
      $controller_api_address = hiera('openstack::controller::address::virtual')
      $storage_api_address = hiera('openstack::controller::address::virtual')
      $other_node_address = undef
  }
}
