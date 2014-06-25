class havana::roleha::compute inherits ::havana::roleha {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::novaha::compute': }
}
