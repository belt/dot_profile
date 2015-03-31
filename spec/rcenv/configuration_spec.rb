require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../lib/rcenv')
require 'configuration'

describe RCEnv::Configuration do
  # NOTE: scope dotenv loading to prevent spec contamination
  context 'load from options' do
    it 'sets base_path' do
      spec_env = File.expand_path(File.dirname(__FILE__) + '/../spec.env')

      lambda do
        config = RCEnv::Configuration.new base_path: File.join('here', '.bash')
        expect(config.base_path).to_not be_nil

        base_path = Pathname.new File.join('here', '.bash')
        expect(config.base_path).to eq base_path
      end
    end
  end

  context 'load from spec.env' do
    it 'sets base_path' do
      spec_env = File.expand_path(File.dirname(__FILE__) + '/../new_spec.env')

      lambda do
        config = RCEnv::Configuration.new dotenv_path: spec_env
        expect(config.base_path).to_not be_nil

        base_path = Pathname.new '/belt'
        expect(config.base_path).to eq base_path
      end
    end
  end

  context 'load from default' do
    it 'sets base_path' do
      spec_env = File.expand_path(File.dirname(__FILE__) + '/../spec.env')

      lambda do
        config = RCEnv::Configuration.new
        expect(config.base_path).to_not be_nil
        default_path = Pathname.new File.join(ENV['HOME'], '.bash')
        expect(config.base_path).to eq default_path
      end
    end
  end
end
