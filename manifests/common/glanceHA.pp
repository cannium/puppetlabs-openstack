# Common class for Glance installation
# Private, and should not be used on its own
# The purpose is to have basic Glance auth configuration options
# set so that services like Tempest can access credentials
# on the controller
class havana::common::glanceHA {
    if($::hostname == 'controller01') {
        $auth_address = hiera('openstack::controller::address::01')
        $registry_address = hiera('openstack::storage::address::01')
    } else {
        $auth_address = hiera('openstack::controller::address::02')
        $registry_address = hiera('openstack::storage::address::02)
    }
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
