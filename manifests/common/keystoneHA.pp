class havana::common::keystoneHA {
  if ($::hostname == 'controller01') {
    $admin_bind_host = hiera('openstack::controller::address::01')
  } else {
    $admin_bind_host = hiera('openstack::controller::address::02')
  }

  class { '::keystone':
    admin_token    => hiera('openstack::keystone::admin_token'),
    sql_connection => $::havana::resources::connectorsHA::keystone,
    verbose        => hiera('openstack::verbose'),
    debug          => hiera('openstack::debug'),
    enabled        => true,
    bind_host      => $admin_bind_host, # TODO change to admin_bind_host for Icehouse
  }

  class { '::keystone::roles::admin':
    email        => hiera('openstack::keystone::admin_email'),
    password     => hiera('openstack::keystone::admin_password'),
    admin_tenant => 'admin',
  }
}
