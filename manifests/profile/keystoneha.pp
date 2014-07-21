# The profile to install the Keystone service
class havana::profile::keystoneha {
  ::havana::resources::controllerha { 'keystone': }
  ::havana::resources::firewall { 'Keystone API': port => '5000', }

  include ::havana::common::keystoneha

  include havana::address
  $address = $::havana::address::controller_management_address
  $vip = hiera('openstack::controller::address::virtual')
  class { 'keystone::endpoint':
    public_address   => $vip,
    admin_address    => $vip,
    internal_address => $vip,
    region           => hiera('openstack::region'),
  }

  $tenants = hiera('openstack::tenants')
  $users = hiera('openstack::users')
  create_resources('::havana::resources::tenant', $tenants)
  create_resources('::havana::resources::user', $users)
}
