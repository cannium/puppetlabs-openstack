# The profile to install a local instance of memcache
class havana::profile::memcacheha {
  include havana::address
  $address = $::havana::address::controller_management_address
  class { 'memcached':
    listen_ip => $address, #'127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }
}
