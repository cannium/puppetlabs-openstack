class havana::role::database inherits ::havana::roleHA {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::mysqlHA': }
}
