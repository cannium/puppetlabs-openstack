# The profile to install the Keystone service
class havana::profile::keystoneha {
  ::havana::resources::controllerha { 'keystone': }
  ::havana::resources::database { 'keystone': }
  ::havana::resources::firewall { 'Keystone API': port => '5000', }

  include ::havana::common::keystoneha

  include havana::address
  $address = $::havana::address::controller_management_address
  class { 'keystone::endpoint':
    public_address   => $address,
    admin_address    => $address,
    internal_address => $address,
    region           => hiera('openstack::region'),
  }

  $tenants = hiera('openstack::tenants')
  $users = hiera('openstack::users')
  create_resources('::havana::resources::tenant', $tenants)
  create_resources('::havana::resources::user', $users)
}
