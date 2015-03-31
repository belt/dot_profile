require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/host_platform'

describe RCEnv::Adornment::HostPlatform do
  subject do
    RCEnv::Adornment::HostPlatform.new
  end

  context 'adornment/host_platform' do
    it 'detects host_type' do
      expect(subject.host_type).to_not be_nil
    end

    it 'detects os_type' do
      expect(subject.os_type).to_not be_nil
    end

    it 'detects os_version' do
      expect(subject.os_version).to_not be_nil
    end
  end

  context 'adornment/host_platform#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
