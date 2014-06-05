class havana::role::controllerHA inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::rabbitmqHA': } ->
  class { '::havana::profile::memcacheHA': } ->
  class { '::havana::profile::keystoneHA': } ->
  class { '::havana::profile::glanceHA::api': } ->
  class { '::havana::profile::glanceHA::auth': } ->
  class { '::havana::profile::novaHA::api': } ->
  class { '::havana::profile::novaHA::compute':}
# nova-network here?
  class { '::havana::profile::horizon': }
  class { '::havana::profile::auth_file': }
  class { '::havana::setup::cirros': }
}
