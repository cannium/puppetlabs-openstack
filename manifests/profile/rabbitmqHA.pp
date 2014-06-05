# The profile to install rabbitmq and set the firewall
class havana::profile::rabbitmqHA {
  if($::hostname == 'controller01') {
      $address = hiera('openstack::controller::address::01')
  } else {
      $address = hiera('openstack::controller::address::02')
  }
  class { '::nova::rabbitmq':
    userid             => hiera('openstack::rabbitmq::user'),
    password           => hiera('openstack::rabbitmq::password'),
    cluster_disk_nodes => $address,
  }
}
