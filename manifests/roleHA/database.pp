class havana::roleha::database inherits ::havana::roleha {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::mysqlha': }
}
