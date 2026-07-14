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
# Merges `default_uri_parameters` with resource-level uri_parameters, with resource-level
# uri_parameters taking precedence. Appends the merged parameters to the URI.
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
    $merged_resources = $cups::resources.map |$name, $attrs| {
      $resource_options = if $attrs['options'] { $attrs['options'] } else { {} }
      $merged_options = if $cups::default_options {
        $cups::default_options + $resource_options
      } else {
        $resource_options
      }

      # Handle URI parameter merging
      $resource_uri_params = if $attrs['uri_parameters'] { $attrs['uri_parameters'] } else { {} }
      $merged_uri_params = if $cups::default_uri_parameters {
        $cups::default_uri_parameters + $resource_uri_params
      } else {
        $resource_uri_params
      }

      # Build final URI with URI parameters appended
      $final_uri = if !empty($merged_uri_params) {
        # Convert hash to query string: {timeout: 20, foo: bar} -> /timeout=20&foo=bar
        $query_params = $merged_uri_params.map |$key, $value| { "${key}=${value}" }.join('&')
        "${attrs['uri']}/${query_params}"
      } else {
        $attrs['uri']
      }

      [$name, $attrs + { 'options' => $merged_options, 'uri' => $final_uri }]
    }.convert_to(Hash)

    create_resources('cups_queue', $merged_resources)
  }
}
