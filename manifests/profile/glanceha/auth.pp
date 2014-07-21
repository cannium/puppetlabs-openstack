# The profile to set up the endpoints, auth, and database for Glance
# Because of the include, api must come before auth if colocated
class havana::profile::glanceha::auth {
  ::havana::resources::controllerha { 'glance': }

  $vip = hiera('openstack::controller::address::virtual')
  class  { '::glance::keystone::auth':
    password         => hiera('openstack::glance::password'),
    public_address   => $vip,
    admin_address    => $vip,
    internal_address => $vip,
    region           => hiera('openstack::region'),
  }

}
