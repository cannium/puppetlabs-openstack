# The profile to set up the endpoints, auth, and database for Glance
# Because of the include, api must come before auth if colocated
class havana::profile::glanceHA::auth {
  ::havana::resources::controllerHA { 'glance': }
  ::havana::resources::database { 'glance': }

  if($::hostname == 'controller01') {
      $address = hiera('openstack::storage::address::01')
  } else {
      $address = hiera('openstack::storage::address::02')
  }
  class  { '::glance::keystone::auth':
    password         => hiera('openstack::glance::password'),
    public_address   => $address,
    admin_address    => $address,
    internal_address => $address,
    region           => hiera('openstack::region'),
  }

  include ::havana::common::glanceHA
}
