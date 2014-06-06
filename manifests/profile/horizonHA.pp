# Profile to install the horizon web service
class havana::profile::horizonHA {
  if($::hostname == 'controller01') {
      $address = hiera('openstack::controller::address::01')
  } else {
      $address = hiera('openstack::controller::address::02')
  }
  class { '::horizon':
    fqdn            => [ '127.0.0.1', $address, $::fqdn, '*' ],
    secret_key      => hiera('openstack::horizon::secret_key'),
    cache_server_ip => $address,
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
