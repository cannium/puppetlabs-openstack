# The profile to install rabbitmq and set the firewall
class havana::profile::rabbitmqHA {
  $address = $::havana::profile::baseHA::controller_management_address
  class { '::nova::rabbitmq':
    userid             => hiera('openstack::rabbitmq::user'),
    password           => hiera('openstack::rabbitmq::password'),
    cluster_disk_nodes => $address,
  }
}
