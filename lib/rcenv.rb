$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/rcenv')

# load Configuration before Base so Base can chain addon initializers
require 'configuration'
require 'base'

# load adornment
require 'adornment/base'

# sets environmental variables, functions and aliases based on binaries
# available in PATH, OSTYPE, HOSTNAME, DOMAIN, number of CPUs, etc
module RCEnv
  def self.base_path_from_env
    Pathname.new ENV['RC_HOME']
  end

  def self.base_path_from_home
    Pathname.new File.join(ENV['HOME'], '.bash')
  end
end
