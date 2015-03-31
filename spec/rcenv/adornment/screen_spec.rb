require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/screen'

describe RCEnv::Adornment::Screen do
  subject do
    RCEnv::Adornment::Screen.new
  end

  context 'adornment/screen' do
    it 'sets screen_dir' do
      expect(subject.screen_dir).to match File.join(ENV['HOME'], '.screen')
    end
  end

  context 'adornment/screen#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
