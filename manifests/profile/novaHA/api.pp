# The profile to set up the Nova controller (several services)
class havana::profile::novaHA::api {
  ::havana::resources::controllerHA { 'nova': }
  ::havana::resources::database { 'nova': }
  ::havana::resources::firewall { 'Nova API': port => '8774', }
  ::havana::resources::firewall { 'Nova Metadata': port => '8775', }
  ::havana::resources::firewall { 'Nova EC2': port => '8773', }
  ::havana::resources::firewall { 'Nova S3': port => '3333', }

  if($::hostname == 'controller01') {
      $address = hiera('openstack::controller::address::01')
  } else {
      $address = hiera('openstack::controller::address::02')
  }
  class { '::nova::keystone::auth':
    password         => hiera('openstack::nova::password'),
    public_address   => $address,
    admin_address    => $address,
    internal_address => $address,
    region           => hiera('openstack::region'),
  }

  include ::havana::common::novaHA
}
