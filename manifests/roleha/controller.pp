class havana::roleha::controller inherits ::havana::roleha {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::rabbitmqha': } ->
  class { '::havana::profile::memcacheha': } ->
  class { '::havana::profile::keystoneha': } ->
  class { '::havana::profile::glanceha::api': } ->
  class { '::havana::profile::glanceha::auth': } ->
  class { '::havana::profile::novaha::api': } ->
  class { '::havana::profile::novaha::compute':}
  class { '::havana::profile::horizonha': }
  class { '::havana::profile::auth_fileha': }
  class { '::havana::setup::cirros': }
}
