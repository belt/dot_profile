require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/provenance'

describe RCEnv::Adornment::Provenance do
  subject do
    RCEnv::Adornment::Provenance.new
  end

  context 'adornment/provenance' do
    it 'detects hostname' do
      expect(subject.hostname).to_not be_nil
    end

    it 'ensures domain' do
      expect(subject.domain).to_not be_nil
    end
  end

  context 'adornment/provenance#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
