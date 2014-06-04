node 'puppet' {
  include ::ntp
}

node 'controller01' {
  include havana::resources::haproxy
}

node 'controller02' {
  include havana::resources::haproxy
}

node 'database' {
  include ::ntp
  include havana::role::database
}
