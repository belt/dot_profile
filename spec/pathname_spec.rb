require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'pathname'

describe 'Pathname' do
  context '#compact_path' do
    subject do
      Pathname.new File.join(ENV['HOME'], "")
    end

    it 'should drop trailing slashes' do
      expect(subject.compact_path.to_s).to_not match(/\/\z/x)
    end

    it 'should substitue ${HOME}/ for ~' do
      expect(subject.compact_path.to_s).to match(/\A ~/x)
    end
  end

  context '#fully_qualified_path' do
    subject do
      Pathname.new ENV['HOME']
    end

    it 'should expand ~ to ${HOME}/' do
      expect(subject.fully_qualified_path.to_s).to match(/\A #{ENV['HOME']} /x)
    end

    it 'should expand ~root to the system-equivalent of /root/' do
      path = Pathname.new '~root'
      expect(path.fully_qualified_path.to_s).to eq File.expand_path('~root') + '/'
    end

    it 'should add trailing slashes on directories' do
      expect(subject.fully_qualified_path.to_s).to match(/\/\z/x)
    end
  end
end
