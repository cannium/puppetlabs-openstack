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

  $address01 = hiera('openstack::controller::address::01')
  $address02 = hiera('openstack::controller::address::02')
  $qpid_hosts = ["${address01}:5672", "${address02}:5672"]

  if($other_node_address) { # means this is a controller node
    $memcached = ["${controller_management_address}:11211",
                  "${other_node_address}:11211"]
  } else {
    $memcached = ["${controller_management_address}:11211"]
  }

  if($is_compute) {
    $nova_state_path = '/var/lib/nova'
  } else {
    $nova_state_path = hiera('openstack::nova::state_path')
  }

  class { '::nova':
    sql_connection     => $::havana::resources::connectorsha::nova,
    glance_api_servers => "http://${vip}:9292",
    memcached_servers  => $memcached,
    monitoring_notifications => true,
    rpc_backend        => 'nova.openstack.common.rpc.impl_qpid',
    qpid_hostname      => hiera('openstack::qpid::hostname'),
    qpid_username      => hiera('openstack::qpid::user'),
    qpid_password      => hiera('openstack::qpid::password'),
    state_path         => $nova_state_path,
    debug              => hiera('openstack::debug'),
    verbose            => hiera('openstack::verbose'),
  }

  nova_config { 
    'DEFAULT/default_floating_pool': value => 'public';
    'DEFAULT/my_ip':  value => $controller_management_address;
    'DEFAULT/allow_resize_to_same_host':  value => 'True';
    'DEFAULT/firewall_driver':  value => 'nova.virt.firewall.NoopFirewallDriver';
    'DEFAULT/multi_host':  value => 'True';
    'DEFAULT/instance_usage_audit': value => 'True';
    'DEFAULT/instance_usage_audit_period':  value => 'hour';
    'DEFAULT/notify_on_state_change': value => 'vm_and_task_state';
    'DEFAULT/qpid_hosts': value => join($qpid_hosts, ',');
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
