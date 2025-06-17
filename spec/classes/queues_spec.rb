# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'cups::queues' do
  on_supported_os.each do |os, os_facts|
    context 'with default values for all parameters' do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('cups::queues::default') }

      it { is_expected.to contain_class('cups::queues::resources') }

      it { is_expected.to contain_class('cups::queues::unmanaged') }
    end
  end
end
