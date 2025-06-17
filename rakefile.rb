# frozen_string_literal: true

require 'bundler'
require 'puppet_litmus/rake_tasks' if Gem.loaded_specs.key? 'puppet_litmus'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-strings/tasks' if Gem.loaded_specs.key? 'puppet-strings'

# disabled checks
PuppetLint.configuration.send('disable_relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.send('disable_manifest_whitespace_opening_brace_after')
PuppetLint.configuration.send('disable_manifest_whitespace_opening_brace_before')
PuppetLint.configuration.send('disable_manifest_whitespace_closing_brace_after')
PuppetLint.configuration.send('disable_manifest_whitespace_closing_brace_before')
PuppetLint.configuration.send('disable_manifest_whitespace_opening_bracket_after')
PuppetLint.configuration.send('disable_manifest_whitespace_opening_bracket_before')
PuppetLint.configuration.send('disable_manifest_whitespace_closing_bracket_after')
PuppetLint.configuration.send('disable_manifest_whitespace_closing_bracket_before')
PuppetLint.configuration.send('disable_manifest_whitespace_two_empty_lines')
PuppetLint.configuration.send('disable_manifest_whitespace_arrows_single_space_after')
PuppetLint.configuration.send('disable_manifest_whitespace_class_name_single_space_after')

# do not fail job if checks are flagged as warnings
PuppetLint.configuration.fail_on_warnings = false

PuppetLint.configuration.ignore_paths = [".vendor/**/*.pp", ".bundle/**/*.pp", "pkg/**/*.pp", "spec/**/*.pp", "tests/**/*.pp", "types/**/*.pp", "vendor/**/*.pp"]
