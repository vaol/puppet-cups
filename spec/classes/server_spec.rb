# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'cups::server' do
  on_supported_os.each do |os, os_facts|
    context 'with default values for all parameters' do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('cups::server::config').that_notifies('Class[cups::server::services]') }

      it { is_expected.to contain_class('cups::server::services') }
    end
  end
end
