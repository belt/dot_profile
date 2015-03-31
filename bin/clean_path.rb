#!/usr/bin/ruby

require 'pathname'
base_path = Pathname.new File.join(__FILE__, '..', '..')
lib_path = Pathname.new(File.join(base_path, 'lib')).cleanpath
$LOAD_PATH.push base_path
require File.join(lib_path, 'pathname')
require File.join(lib_path, 'path_cleaner')

#puts PathCleaner.new.to_s(shorten_paths: true) if $PROGRAM_NAME == __FILE__
puts PathCleaner.new if $PROGRAM_NAME == __FILE__
