# The puppet module to set up a Nova Compute node
class havana::profile::novaHA::compute {

  if($::hostname == 'controller01') {
      $management_network = hiera('openstack::network::address::01')
  } else {
      $management_network = hiera('openstack::network::address::02')
  }
  $management_address = ip_for_network($management_network)

  class { '::havana::common::novaHA':
    is_compute => true,
  }

  class { '::nova::compute::libvirt':
    libvirt_type     => hiera('openstack::nova::libvirt_type'),
    vncserver_listen => $management_address,
  }

  file { '/etc/libvirt/qemu.conf':
    ensure => present,
    source => 'puppet:///modules/havana/qemu.conf',
    mode   => '0644',
    notify => Service['libvirt'],
  }

  Package['libvirt'] -> File['/etc/libvirt/qemu.conf']
}
