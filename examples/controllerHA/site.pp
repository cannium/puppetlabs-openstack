node 'puppet' {
  include ::ntp
}

node 'controller01' {
  class{'::havana::resources::haproxy':} ->
  class{'::havana::resources::keepalived':} ->
  class{'::havana::roleha::controller':}
}

node 'controller02' {
  class{'::havana::resources::haproxy':} ->
  class{'::havana::resources::keepalived':} ->
  class{'::havana::roleha::controller':}
}

node 'database' {
  include ::havana::roleha::database
}
