require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/ls'

describe RCEnv::Adornment::Ls do
  subject do
    RCEnv::Adornment::Ls.new
  end

  context 'adornment/ls' do
    it 'sets ls alias' do
      expect(subject.alias_ls).to_not be_nil
    end

    it 'sets ls-colors if available' do
      expect(subject.ls_colors).to_not be_nil
    end

    it 'auto-sets ls-colors if available' do
      expect(subject.auto_ls_colors).to_not be_nil
    end
  end

  context 'adornment/ls#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
