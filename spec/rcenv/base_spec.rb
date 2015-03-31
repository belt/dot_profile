require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../lib/rcenv')
require 'base'

describe RCEnv::Base do
  subject do
    RCEnv::Base.new
  end

  context 'adornments' do
    it 'default configuration exists' do
      expect(subject.configuration).to_not be_nil
    end

    it 'parameter configuration exists' do
      subject = RCEnv::Base.new prompt: { prompt_type: :git }
      expect(subject.adornments.adornments[:prompt].prompt_type).to be :git
    end

    it 'initializes adornments' do
      expect(subject.adornments).to_not be_nil
    end

    it 'can shellify' do
      expect(subject.to_sh).to_not be_nil
    end
  end
end
