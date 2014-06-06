# The profile to install the Keystone service
class havana::profile::keystoneHA {
  ::havana::resources::controllerHA { 'keystone': }
  ::havana::resources::database { 'keystone': }
  ::havana::resources::firewall { 'Keystone API': port => '5000', }

  include ::havana::common::keystoneHA

  $address = $::havana::profile::baseHA::controller_management_address
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
