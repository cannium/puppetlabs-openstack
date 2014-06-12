class havana::resources::connectorsha {
  $database_address = hiera('openstack::mysql::address')
  $password = hiera('openstack::mysql::service_password')

  $keystone = "mysql://keystone:${password}@${database_address}/keystone"
  $cinder   = "mysql://cinder:${password}@${database_address}/cinder"
  $glance   = "mysql://glance:${password}@${database_address}/glance"
  $nova     = "mysql://nova:${password}@${database_address}/nova"
  $neutron  = "mysql://neutron:${password}@${database_address}/neutron"
  $heat     = "mysql://heat:${password}@${database_address}/heat"

  include mysql::server
}
