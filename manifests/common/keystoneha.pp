class havana::common::keystoneha {
  include havana::address
  $admin_bind_host = $::havana::address::controller_management_address

  class { '::keystone':
    admin_token    => hiera('openstack::keystone::admin_token'),
    sql_connection => $::havana::resources::connectorsha::keystone,
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