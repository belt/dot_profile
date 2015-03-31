require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/terminal'

describe RCEnv::Adornment::Terminal do
  subject do
    RCEnv::Adornment::Terminal.new
  end

  context 'adornment/terminal' do
    it 'detects TERM' do
      expect(subject.term).to_not be_empty
    end

    it 'ensures TERM is set appropriately' do
      expect(subject.term).to eq 'xterm'
    end

    it 'detects TERM_PROGRAM' do
      expect(subject.term_program).to_not be_nil
    end
  end

  context 'adornment/terminal#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
