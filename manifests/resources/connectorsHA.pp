class havana::resources::connectorsha {

  $management_address = $::havana::profile::baseha::controller_management_address
  $password = hiera('openstack::mysql::service_password')

  $keystone = "mysql://keystone:${password}@${management_address}/keystone"
  $cinder   = "mysql://cinder:${password}@${management_address}/cinder"
  $glance   = "mysql://glance:${password}@${management_address}/glance"
  $nova     = "mysql://nova:${password}@${management_address}/nova"
  $neutron  = "mysql://neutron:${password}@${management_address}/neutron"
  $heat     = "mysql://heat:${password}@${management_address}/heat"
}
