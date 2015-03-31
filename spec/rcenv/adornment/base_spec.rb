require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/base'

describe RCEnv::Adornment::Base do
  subject do
    RCEnv::Adornment::Base.new
  end

  context 'adornment/base#new' do
    it 'initializes' do
      expect(subject.adornments).to_not be_nil
    end
  end

  context 'adornment/base#to_sh' do
    it 'should raise error' do
      expect { subject.to_sh }.to raise_error, ':sh_sh not implemented'
    end
  end
end
