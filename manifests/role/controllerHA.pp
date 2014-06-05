class havana::role::controllerHA inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::rabbitmq': } ->
  class { '::havana::profile::memcache': } ->
  class { '::havana::profile::mysql': } ->
  class { '::havana::profile::keystoneHA': } ->
  class { '::havana::profile::glance::api': } ->
  class { '::havana::profile::glance::auth': } ->
  class { '::havana::profile::cinder::api': } ->
  class { '::havana::profile::nova::api': } ->
  class { '::havana::profile::cinder::volume': }
# nova-network here?
  class { '::havana::profile::horizon': }
  class { '::havana::profile::auth_file': }
  class { '::havana::setup::cirros': }
}
