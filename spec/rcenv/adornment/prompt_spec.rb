require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/prompt'

describe RCEnv::Adornment::Prompt do
  subject do
    RCEnv::Adornment::Prompt.new
  end

  context 'adornment/prompt' do
    it 'sets prompt_type default' do
      expect(subject.prompt_type).to eq 'simple'
    end

    it 'sets prompt_type by parameter' do
      subject = RCEnv::Adornment::Prompt.new prompt_type: :git
      expect(subject.prompt_type).to eq :git
    end
  end

  context 'adornment/prompt#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
