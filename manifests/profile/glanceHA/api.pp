# The profile to install the Glance API and Registry services
# Note that for this configuration API controls the storage,
# so it is on the storage node instead of the control node
class havana::profile::glanceHA::api {
  $api_network = hiera('openstack::network::api')
  $api_address = ip_for_network($api_network)

  $management_network = hiera('openstack::network::management')
  $management_address = ip_for_network($management_network)

  $explicit_address = $::havana::profile::baseHA::storage_management_address
  $controller_address = $::havana::profile::baseHA::controller_management_addres

  if $management_address != $explicit_address {
    fail("Glance Auth setup failed. The inferred location of Glance from
    the openstack::network::management hiera value is
    ${management_address}. The explicit address from
    openstack::storage::address:: is ${explicit_address}.
    Please correct this difference.")
  }

  ::havana::resources::firewall { 'Glance API': port      => '9292', }
  ::havana::resources::firewall { 'Glance Registry': port => '9191', }

  include ::havana::common::glanceHA

  class { '::glance::backend::file': 
      filesystem_store_datadir  => hiera('openstack::glance::filesystem_store_datadir'),
      scrubber_datadir          => hiera('openstack::glance::scrubber_datadir'),
      image_cache_dir           => hiera('openstack::glance::image_cache_dir'),
  }

  class { '::glance::registry':
    keystone_password => hiera('openstack::glance::password'),
    sql_connection    => $::havana::resources::connectorsHA::glance,
    auth_host         => $::hostname,
    keystone_tenant   => 'services',
    keystone_user     => 'glance',
    verbose           => hiera('openstack::verbose'),
    debug             => hiera('openstack::debug'),
  }

  class { '::glance::notify::rabbitmq': 
    rabbit_password => hiera('openstack::rabbitmq::password'),
    rabbit_userid   => hiera('openstack::rabbitmq::user'),
    rabbit_host     => $controller_address,
  }
}
