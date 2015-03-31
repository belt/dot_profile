require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.order = 'random'
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../bin')
require 'clean_path'

describe 'PathCleaner' do
  context 'empty paths' do
    subject do
      PathCleaner.new '/bin::/sbin'
    end

    it 'should be removed' do
      expect(subject.ordered_paths.join(':')).to eq '/bin:/sbin'
    end
  end

  context '#ordered_paths' do
    subject do
      PathCleaner.new [
        File.join(ENV['HOME'], 'bin'),
        File.join(ENV['HOME'], 'sbin'),
        File.join(ENV['HOME'], '.rvm', 'bin'),
        '/bin',
        '/bin',
        '/sbin',
        '/sbin',
        '',
        '/this/path/should/not/exist',
        '/usr/bin',
        '/usr/sbin',
        '/usr/local/bin',
        '/usr/local/sbin',
        '/opt/X11/bin',
        '/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Commands',
        '~/Qt/5.3/clang_64/bin/'
      ].shuffle.join(':')
    end

    before :each do
      subject.prioritize_paths
      @paths = subject.ordered_paths
    end

    it 'should not contain paths that do not exist on the file-system' do
      expect(@paths).to_not include(File.join('this', 'path', 'should', 'not', 'exist'))
    end

    it 'should not contain duplicate paths' do
      expect(@paths.select { |path| path.to_s.match(/\A \/bin \z/x) }.count).to be(1)
      expect(@paths.select { |path| path.to_s.match(/\A \/sbin \z/x) }.count).to be(1)
    end
  end

  context 'short paths' do
    subject do
      PathCleaner.new File.join(File.expand_path(ENV['HOME']), 'bin')
    end

    it 'should replace ${HOME}/ with ~' do
      expect(subject.to_s(shorten_paths: true)).to eq File.join('~', 'bin')
    end
  end

  context 'fully qualified paths' do
    subject do
      PathCleaner.new File.join('~', 'bin')
    end

    it 'should replace ~ with ${HOME}/' do
      expect(subject.to_s(fully_qualified_paths: true)).to eq File.join(ENV['HOME'], 'bin', "")
    end
  end

  context 'should prioritize' do
    subject do
      PathCleaner.new [
        File.join(ENV['HOME'], 'bin'),
        File.join(ENV['HOME'], 'sbin'),
        File.join(ENV['HOME'], '.rvm', 'bin')
      ].shuffle.join(':')
    end

    context 'the accounts\' ${HOME}/ directory' do
      before :each do
        @base = ENV['HOME']
      end

      subject do
        PathCleaner.new [
          File.join(@base, 'bin'), File.join(@base, 'sbin'),
          File.join(@base, %w(.rvm bin))
        ].shuffle.join(':')
      end

      it 'having bin/ before sbin/ directories' do
        subject.send :prioritize_home_bin_dir, 'bin'
        expect(subject.ordered_paths[0]).to eq Pathname.new Pathname.new File.join(@base, 'bin')

        subject.send :prioritize_home_bin_dir, 'sbin'
        expect(subject.ordered_paths[0]).to eq Pathname.new Pathname.new File.join(@base, 'sbin')
      end

      it 'remaining directories' do
        subject.send :prioritize_home_bins
        expect(subject.ordered_paths[0]).to eq Pathname.new Pathname.new File.join(@base, '.rvm', 'bin')
      end

      it 'order is ${HOME}/bin/:${HOME}/sbin/' do
        path = [
          File.join(@base, 'bin'), File.join(@base, 'sbin'),
          File.join(@base, %w(.rvm bin))
        ].join(':')
        expect(subject.send(:prioritize_home_dirs).join(':')).to eq path
      end
    end

    context 'the accounts\' ~ alias' do
      subject do
        PathCleaner.new [
          File.join(%w(~ bin)), File.join(%w(~ sbin)),
          File.join(%w(~ .rvm bin))
        ].shuffle.join(':')
      end

      it 'having bin/ before sbin/ directories' do
        subject.send :prioritize_home_bin_dir, 'bin'
        expect(subject.ordered_paths[0]).to eq Pathname.new File.join('~', 'bin')

        subject.send :prioritize_home_bin_dir, 'sbin'
        expect(subject.ordered_paths[0]).to eq Pathname.new File.join('~', 'sbin')
      end

      it 'remaining directories' do
        subject.send :prioritize_home_bins
        expect(subject.ordered_paths[0]).to eq Pathname.new File.join('~', '.rvm', 'bin')
      end

      it 'order is ~/bin/:~/sbin/' do
        subject.send :prioritize_home_dirs

        path = [
          File.join('~', 'bin'), File.join('~', 'sbin'),
          File.join('~', %w(.rvm bin))
        ].join(':')
        expect(subject.ordered_paths.join(':')).to eq path
      end
    end

    context 'the default system directories' do
      subject do
        PathCleaner.new [
          '/bin', '/sbin', '/usr/local/bin', '/usr/local/sbin', '/usr/bin', '/usr/sbin'
        ].shuffle.join(':')
      end

      it 'having /bin/ before /sbin/ before /usr/bin/ before /usr/sbin/' do
        subject.send :prioritize_default
        expect(subject.ordered_paths[0]).to eq Pathname.new File.join("", 'bin')
        expect(subject.ordered_paths[1]).to eq Pathname.new File.join("", 'sbin')
        expect(subject.ordered_paths[2]).to eq Pathname.new File.join("", 'usr', 'bin')
        expect(subject.ordered_paths[3]).to eq Pathname.new File.join("", 'usr', 'sbin')
      end

      it 'order is /bin/:/sbin/:/usr/bin/:/usr/sbin/' do
        subject.send :prioritize_default

        path = ['/bin', '/sbin', '/usr/bin', '/usr/sbin'].join(':')
        expect(subject.ordered_paths.join(':')).to match(/\A#{path}/)
      end
    end

    context '/usr/local/* directories' do
      subject do
        PathCleaner.new [
          '/bin', '/sbin', '/usr/local/bin', '/usr/local/sbin', '/usr/bin', '/usr/sbin'
        ].shuffle.join(':')
      end

      it 'having /usr/local/bin/ before /usr/local/sbin/' do
        subject.send :prioritize_usr_local
        expect(subject.ordered_paths[0]).to eq Pathname.new File.join("", 'usr', 'local', 'bin')
        expect(subject.ordered_paths[1]).to eq Pathname.new File.join("", 'usr', 'local', 'sbin')
      end

      it 'order is /usr/local/bin/:/usr/local/sbin/' do
        subject.send :prioritize_usr_local

        path = ['/usr/local/bin', '/usr/local/sbin'].join(':')
        expect(subject.ordered_paths.join(':')).to match(/\A#{path}/)
      end
    end
  end
end
