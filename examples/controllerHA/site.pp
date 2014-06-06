node 'puppet' {
  include ::ntp
}

node 'controller01' {
  include ::havana::resources::haproxy
  include ::havana::resources::keepalived
  include ::havana::roleha::controller
}

node 'controller02' {
  include ::havana::resources::haproxy
  include ::havana::resources::keepalived
  include ::havana::roleha::controller
}

node 'database' {
  include ::havana::roleha::database
}
