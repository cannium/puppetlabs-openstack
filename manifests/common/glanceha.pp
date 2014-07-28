# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class havana::common::glanceha {
  include havana::address
  $management_address = $::havana::address::controller_management_address
  $registry_address = $::havana::address::storage_management_address
  $vip = hiera('openstack::controller::address::virtual')
  class { '::glance::api':
    keystone_password => hiera('openstack::glance::password'),
    auth_host         => $vip,
    bind_host         => $management_address,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    sql_connection    => $::havana::resources::connectorsha::glance,
    registry_host     => $vip,
    verbose           => hiera('openstack::verbose'),
    debug             => hiera('openstack::debug'),
    enabled           => true,
  }
}
