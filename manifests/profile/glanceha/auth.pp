# The profile to set up the endpoints, auth, and database for Glance
# Because of the include, api must come before auth if colocated
class havana::profile::glanceha::auth {
  ::havana::resources::controllerha { 'glance': }

  include havana::address
  $address = $::havana::address::controller_management_address
  class  { '::glance::keystone::auth':
    password         => hiera('openstack::glance::password'),
    public_address   => $address,
    admin_address    => $address,
    internal_address => $address,
    region           => hiera('openstack::region'),
  }

  include ::havana::common::glanceha
}
