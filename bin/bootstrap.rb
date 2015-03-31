#!/usr/bin/ruby

fail "${USER} is not set" unless ENV['USER']

unless ENV['HOME']
  warn "${HOME} is not set"
  ENV['HOME'] = File.join("", 'home', ENV['USER'])
end

fail "${HOME} and ${USER} are not set" unless ENV['HOME'] && ENV['USER']

require 'pp'
require 'pathname'
require 'pry-byebug'
base_path = Pathname.new File.join(File.dirname(__FILE__), '..')
lib_path = Pathname.new(File.join(base_path, 'lib')).cleanpath
$LOAD_PATH.push base_path
require File.join(lib_path, 'rcenv')

#puts PathCleaner.new.to_s(shorten_paths: true) if $PROGRAM_NAME == __FILE__
base = RCEnv::Base.new prompt: { prompt_type: :git }
puts base.to_sh

# set minimum environment
#   configures logging
#   sets and exports HOME
#   loads dotbash configuration
#   loads domain env
#   loads host env
#   detects DOMAIN
#   detects HOSTNAME
#   detects HOST
#   sets dotbash aliases
#   write cache file
#
# dotbash
#   exports
#   functions
#   prompt
#   aliases
#
#   environment detection / plugins / cache
#
#   manual overrides
#
#   simplifies paths

# BOOTSTRAP
# |
# +> load cache file
# | -OR-
# +> detect programs in existing path
# |
