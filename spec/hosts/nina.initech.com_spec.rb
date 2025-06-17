# frozen_string_literal: true

require 'spec_helper'

RSpec.configure do |c|
  c.manifest = "#{Dir.pwd}/spec/fixtures/manifests/site.pp"
end

RSpec.describe 'nina.initech.com' do
  on_supported_os.each do |os, os_facts|
    let(:facts) do
      os_facts.merge(
        certname: 'nina.initech.com',
      )
    end

    if Puppet::PUPPETVERSION.to_f < 4.9
      let(:hiera_config) { 'spec/fixtures/hiera3.yaml' }
    else
      let(:hiera_config) { 'spec/fixtures/hiera5.yaml' }
    end

    context 'when using a hiera example' do
      it { is_expected.to contain_class('cups').with(web_interface: true) }

      it { is_expected.to contain_cups_queue('Warehouse').with(ensure: 'printer') }

      it { is_expected.to contain_cups_queue('GroundFloor').with(ensure: 'class', members: %w[Office Warehouse]) }
    end
  end
end
