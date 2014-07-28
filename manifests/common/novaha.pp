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

  $qpid_hosts = hiera('openstack::qpid::hosts')

  $controller01 = hiera('openstack::controller::address::01')
  $controller02 = hiera('openstack::controller::address::02')
  # memcached address configuration should be consist through the deployment,
  # see https://code.google.com/p/memcached/wiki/NewConfiguringClient#Configuring_Servers_Consistently for details
  $cache_address = ["${controller01}:11211", "${controller02}:11211"]

  if($is_compute) {
    $nova_state_path = '/var/lib/nova'
    $myip            = $management_address
  } else {
    $nova_state_path = hiera('openstack::nova::state_path')
    $myip            = $controller_management_address
  }

  class { '::nova':
    sql_connection     => $::havana::resources::connectorsha::nova,
    glance_api_servers => "http://${vip}:9292",
    memcached_servers  => $cache_address,
    monitoring_notifications => true,
    rpc_backend        => 'nova.openstack.common.rpc.impl_qpid',
    qpid_hostname      => hiera('openstack::qpid::hostname'),
    qpid_username      => hiera('openstack::qpid::user'),
    qpid_password      => hiera('openstack::qpid::password'),
    state_path         => $nova_state_path,
    nova_shell         => "/bin/bash",
    debug              => hiera('openstack::debug'),
    verbose            => hiera('openstack::verbose'),
  }

  nova_config { 
    'DEFAULT/default_floating_pool': value => 'public';
    'DEFAULT/my_ip':  value => $myip;
    'DEFAULT/allow_resize_to_same_host':  value => 'True';
    'DEFAULT/firewall_driver':  value => 'nova.virt.firewall.NoopFirewallDriver';
    'DEFAULT/multi_host':  value => 'True';
    'DEFAULT/instance_usage_audit': value => 'True';
    'DEFAULT/instance_usage_audit_period':  value => 'hour';
    'DEFAULT/notify_on_state_change': value => 'vm_and_task_state';
    'DEFAULT/qpid_hosts': value => join($qpid_hosts, ',');
  }

  $backdoor_port = hiera('openstack::nova::eventlet_backdoor_port')
  if($backdoor_port) {
      nova_config { 'DEFAULT/backdoor_port': value => $backdoor_port }
  }

  class { '::nova::api':
    admin_password                       => hiera('openstack::nova::password'),
    api_bind_address                     => $controller_management_address,
    metadata_listen                      => $controller_management_address,
    auth_host                            => $vip,
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

  class { '::nova::compute':
    enabled                       => $is_compute,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $management_address,
    vncproxy_host                 => $vip,
  }

  class { '::nova::network':
    fixed_range             => hiera('openstack::nova::network::fixed_range'),
    private_interface       => hiera('openstack::nova::network::private_interface'),
    public_interface        => hiera('openstack::nova::network::public_interface'),
    enabled                 => true,
    network_manager         => 'nova.network.manager.FlatDHCPManager',
  }
}
