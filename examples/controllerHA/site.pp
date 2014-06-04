node 'puppet' {
  include ::ntp
}

node 'controller01' {
}

node 'controller02' {
}

node 'database' {
  include ::ntp
  include havana::role::database
}
