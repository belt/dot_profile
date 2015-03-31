# cleans the sytem path
class PathCleaner
  attr_accessor :ordered_paths

  def initialize(opts = nil)
    lopts = opts || ARGV[0] || ""

    # windows uses ; && everyone else uses :
    @path_delimeter = ':'

    @paths = lopts.split(/#{@path_delimeter}+/).uniq || []
    @ordered_paths = @paths.map { |path| Pathname.new path }

    @antecedent = []
  end

  def prioritize_paths
    prioritize_default
    prioritize_usr_local
    prioritize_home_dirs
  end

  def to_s(opts = {})
    prune_blacklist
    prioritize_paths

    prune_non_existing if opts[:prune_paths]

    if opts[:shorten_paths]
      @ordered_paths.map(&:compact_path).join(@path_delimeter)
    elsif opts[:fully_qualified_paths]
      @ordered_paths.map(&:fully_qualified_path).join(@path_delimeter)
    else
      @ordered_paths.join(@path_delimeter)
    end
  end

  protected

  def reorder_paths
    clean_paths = @ordered_paths.map(&:to_s)
    clean_paths = (clean_paths & @antecedent) + (clean_paths - @antecedent)
    @ordered_paths = clean_paths.map { |path| Pathname.new path }
  end

  def prioritize_home_dirs
    prioritize_home_bins
    prioritize_home_bin_dir('sbin')
    prioritize_home_bin_dir('bin')
  end

  def prioritize_home_bin_dir(path)
    @antecedent = [File.join(ENV['HOME'], path), File.join('~', path)]
    reorder_paths
  end

  def prioritize_home_bins
    @antecedent = @ordered_paths.select do |path|
      path.to_s.match(ENV['HOME']) || path.to_s.match(/\A ~/x)
    end
    @antecedent.map!(&:to_s)

    @antecedent -= [File.join(ENV['HOME'], 'bin'),
                    File.join('~', 'bin'),
                    File.join(ENV['HOME'], 'sbin'),
                    File.join('~', 'sbin')]

    reorder_paths
  end

  def prioritize_default
    ['/bin', '/sbin', '/usr/bin', '/usr/sbin'].reverse.each do |path|
      @antecedent = [path]
      reorder_paths
    end
  end

  def prioritize_usr_local
    ['/usr/local/bin', '/usr/local/sbin'].reverse.each do |path|
      @antecedent = [path]
      reorder_paths
    end
  end

  def prune_blacklist
    @ordered_paths -= ['.', '..']
  end

  def prune_non_existing
    @ordered_paths.reject! { |path| !File.exist? path }
  end
end
