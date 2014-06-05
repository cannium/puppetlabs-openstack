# The profile to install a local instance of memcache
class havana::profile::memcacheHA {
  if($::hostname == 'controller01') {
      $address = hiera('openstack::controller::address::01')
  } else {
      $address = hiera('openstack::controller::address::02')
  }
  class { 'memcached':
    listen_ip => $address, #'127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }
}
