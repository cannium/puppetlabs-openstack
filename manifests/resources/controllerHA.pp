# A basic defined resource that only checks for controller
# configuration consistency with the Hiera data
define havana::resources::controllerha () {
  $address = $::havana::profile::baseha::controller_management_address
  unless has_ip_address($address) {
    fail("${title} setup failed. This node is listed
    as a controller, but does not have the ip address
    ${address}.")
  }

}
