node 'puppet' {
  include ::ntp
}

node 'controller01' {
  include havana::resources::haproxy
  include havana::resources::keepalived
  include havana::role::controllerHA
}

node 'controller02' {
  include havana::resources::haproxy
  include havana::resources::keepalived
  include havana::role::controllerHA
}

node 'database' {
  include ::ntp
  include havana::role::database
}
