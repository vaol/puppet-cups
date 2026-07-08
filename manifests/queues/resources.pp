# Private class
#
# @summary Creates cups_queue resources from hashes.
#
# This class is a convenience wrapper around the `create_resources` function.
# It inherits the `resources` attribute from the public {cups} class
# and enables Hiera or any other ENC to create {puppet_types::cups_queue} resources.
#
# Merges `default_options` with resource-level options, with resource-level
# options taking precedence.
#
# @author Leo Arnold
# @since 2.0.0
#
# @example This class is implicitly used when providing Hiera data like
#   cups::resources:
#     Warehouse:
#       ensure: printer
#       model: drv:///sample.drv/generic.ppd
#       uri: socket://warehouse.initech.com
#
class cups::queues::resources {
  if ($cups::resources) {
    if ($cups::default_options) {
      $merged_resources = $cups::resources.map |$name, $attrs| {
        $resource_options = if $attrs['options'] { $attrs['options'] } else { {} }
        $merged_options = $cups::default_options + $resource_options
        [$name, $attrs + { 'options' => $merged_options }]
      }.convert_to(Hash)
      create_resources('cups_queue', $merged_resources)
    } else {
      create_resources('cups_queue', $cups::resources)
    }
  }
}
