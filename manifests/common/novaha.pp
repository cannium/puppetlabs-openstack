# Common class for nova installation
# Private, and should not be used on its own
# usage: include from controller, declare from worker
# This is to handle dependency
# depends on openstack::profile::base having been added to a node
class havana::common::novaha (
        $is_compute = false,
        $is_controller = true,
  ) {

  $management_network = hiera('openstack::network::management')
  $management_address = ip_for_network($management_network)

  include havana::address
  $storage_management_address = $::havana::address::storage_management_address
  $controller_management_address = $::havana::address::controller_management_address
  $other_node_address = $::havana::address::other_node_address
  $vip = hiera('openstack::controller::address::virtual')

  class { '::nova':
    sql_connection     => $::havana::resources::connectorsha::nova,
    glance_api_servers => "http://${vip}:9292",
    memcached_servers  => ["${controller_management_address}:11211",
                           "${other_node_address}:11211"],
    monitoring_notifications => true,
    rabbit_hosts       => [$controller_management_address,
                           $other_node_address],
    rabbit_userid      => hiera('openstack::rabbitmq::user'),
    rabbit_password    => hiera('openstack::rabbitmq::password'),
    debug              => hiera('openstack::debug'),
    verbose            => hiera('openstack::verbose'),
  }

  nova_config { 'DEFAULT/default_floating_pool': value => 'public' }

  class { '::nova::api':
    admin_password                       => hiera('openstack::nova::password'),
    api_bind_address                     => $controller_management_address,
    metadata_listen                      => $controller_management_address,
    auth_host                            => $controller_management_address,
    enabled                              => $is_controller,
  }

  class { '::nova::vncproxy':
    host    => $controller_management_address,
    enabled => $is_controller,
  }

  class { [
    'nova::scheduler',
    'nova::objectstore',
    'nova::cert',
    'nova::consoleauth',
    'nova::conductor'
  ]:
    enabled => $is_controller,
  }

  # TODO: it's important to set up the vnc properly
  class { '::nova::compute':
    enabled                       => $is_compute,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $management_address,
    vncproxy_host                 => $vip,
  }

  class { '::nova::network':
    fixed_range             => '10.1.1.0/24',
    private_interface       => 'eth1',
    public_interface        => 'eth0',
    enabled                 => true,
    network_manager         => 'nova.network.manager.FlatDHCPManager',
  }
}
