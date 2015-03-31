require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../../lib/rcenv')
require 'adornment/keychain'

describe RCEnv::Adornment::Keychain do
  subject do
    RCEnv::Adornment::Keychain.new
  end

  context 'adornment/keychain#to_sh' do
    it 'should yield a string' do
      expect(subject.to_sh).to_not be_nil
    end
  end

  context 'adornment/keychain#exec_keychain' do
    before :all do
      @keychain_file = "#{ENV['HOME']}/.keychain/#{Socket.gethostname}-sh"
      FileUtils.mv @keychain_file, "#{@keychain_file}.#{Process.pid}"
    end

    after :all do
      FileUtils.mv "#{@keychain_file}.#{Process.pid}", @keychain_file
    end

    it 'writes ~/.keychain/HOSTNAME-sh' do
      subject.exec_keychain
      expect { File.exist? @keychain_file }
    end
  end

  context 'adornment/keychain#keychain_file' do
    before :all do
      @keychain_file = "#{ENV['HOME']}/.keychain/#{Socket.gethostname}-sh"
      subject.exec_keychain unless File.exist? @keychain_file
    end

    context 'caches ~/.keychain/HOSTNAME-sh' do
      it 'sets ssh_auth_sock' do
        expect(subject.ssh_auth_sock).to_not be_nil
      end

      it 'sets ssh_agent_pid' do
        expect(subject.ssh_agent_pid).to match /\d+/
      end
    end

    context 'content of ~/.keychain/HOSTNAME-sh' do
      it 'SSH_AUTH_SOCK' do
        expect(subject.ssh_auth_sock_from_keychain).to_not be_nil
      end

      it 'SSH_AGENT_PID' do
        expect(subject.ssh_agent_pid_from_keychain).to match /\d+/
      end
    end
  end
end
