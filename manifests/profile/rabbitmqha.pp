# The profile to install rabbitmq and set the firewall
class havana::profile::rabbitmqha {
  include havana::address
  $address = $::havana::address::controller_management_address
  $other_address = $::havana::address::other_node_address
  class { '::nova::rabbitmq':
    userid             => hiera('openstack::rabbitmq::user'),
    password           => hiera('openstack::rabbitmq::password'),
    cluster_disk_nodes => [$address, $other_address],
  }
}
