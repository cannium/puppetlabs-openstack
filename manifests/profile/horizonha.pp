# Profile to install the horizon web service
class havana::profile::horizonha {
  include havana::address
  $address = $::havana::address::controller_management_address
  $controller01 = hiera('openstack::controller::address::01')
  $controller02 = hiera('openstack::controller::address::02')
  $cache_address = [$controller01, $controller02]
  $vip = hiera('openstack::controller::address::virtual')
  class { '::horizon':
    fqdn            => [ '127.0.0.1', $address, $::fqdn, '*' ],
    secret_key      => hiera('openstack::horizon::secret_key'),
    cache_server_ip => $cache_address,
    bind_address    => $address,
    keystone_url    => "http://${vip}:5000/v2.0",
    local_settings_template => "havana/local_settings.py.erb"
  }

  ::havana::resources::firewall { 'Apache (Horizon)': port => '80' }
  ::havana::resources::firewall { 'Apache SSL (Horizon)': port => '443' }

  if $::selinux and str2bool($::selinux) != false {
    selboolean{'httpd_can_network_connect':
      value      => on,
      persistent => true,
    }
  }

}
