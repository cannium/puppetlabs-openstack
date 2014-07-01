# The profile to set up the Nova controller (several services)
class havana::profile::novaha::api {
  ::havana::resources::controllerha { 'nova': }
  ::havana::resources::firewall { 'Nova API': port => '8774', }
  ::havana::resources::firewall { 'Nova Metadata': port => '8775', }
  ::havana::resources::firewall { 'Nova EC2': port => '8773', }
  ::havana::resources::firewall { 'Nova S3': port => '3333', }

  include havana::address
  $address = hiera('openstack::controller::address::virtual')
  class { '::nova::keystone::auth':
    password         => hiera('openstack::nova::password'),
    public_address   => $address,
    admin_address    => $address,
    internal_address => $address,
    region           => hiera('openstack::region'),
  }

  class {'::havana::common::novaha':
    is_compute => false,
    is_controller => true,
  }
}
