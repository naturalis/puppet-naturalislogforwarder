require 'spec_helper'
describe 'naturalislogforwarder' do

  context 'with defaults for all parameters' do
    it { should contain_class('naturalislogforwarder') }
  end
end
