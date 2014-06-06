# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class havana::common::glanceHA {
  $auth_address = $::havana::profile::baseHA::controller_management_address
  $registry_address = $::havana::profile::baseHA::storage_management_address
  class { '::glance::api':
    keystone_password => hiera('openstack::glance::password'),
    auth_host         => $auth_address,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $::havana::resources::connectorsHA::glance,
    registry_host     => $registry_address,
    verbose           => hiera('openstack::verbose'),
    debug             => hiera('openstack::debug'),
    enabled           => true,
  }
}
