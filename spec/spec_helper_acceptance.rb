require 'shellwords'
require 'beaker-rspec'

# RSpec configuration
# http://www.rubydoc.info/github/rspec/rspec-core/RSpec/Core/Configuration
RSpec.configure do |c|
  c.color = true
  c.formatter = :documentation
  c.mock_with(:rspec)
end

# Beaker related configuration
# http://www.rubydoc.info/github/puppetlabs/beaker/Beaker/DSL
RSpec.configure do |c|
  project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  c.before(:suite) do
    hosts.each do |host|
      install_puppet_agent_on(host)
      copy_module_to(host, source: project_root, module_name: 'cups')
    end
  end
end

# Custom helper functions

def ensure_cups_is_running
  apply_manifest('class { "cups": }', catch_failures: true)
end

def add_printers(*names)
  names.each do |name|
    shell("lpadmin -E -p #{Shellwords.escape(name)} -m drv:///sample.drv/generic.ppd -o printer-is-shared=false")
  end
end

def add_printers_to_classes(classmembers)
  add_printers('Dummy')
  classmembers.keys.each do |classname|
    members = classmembers[classname]
    members = %w(Dummy) if members.empty?
    members.each do |printername|
      shell("lpadmin -E -p #{Shellwords.escape(printername)} -c #{Shellwords.escape(classname)}")
    end
    shell("lpadmin -E -p #{Shellwords.escape(classname)} -o printer-is-shared=false")
  end
  remove_queues('Dummy')
end

def remove_queues(*names)
  names.flatten.each do |name|
    shell("lpadmin -E -x #{Shellwords.escape(name)}", acceptable_exit_codes: [0, 1])
  end
end

def purge_all_queues
  request = '{
    OPERATION CUPS-Get-Printers
    GROUP operation
    ATTR charset attributes-charset utf-8
    ATTR language attributes-natural-language en
    STATUS successful-ok
    DISPLAY printer-name
  }'
  result = shell('ipptool -c ipp://localhost/ /dev/stdin', stdin: request, acceptable_exit_codes: [0, 1])
  remove_queues(result.stdout.split("\n")[1..-1]) if result.exit_code.zero?
end
