# Pathname.new.compact_path and Pathname.new.fully_quallified_path
class Pathname
  # :call-seq:
  # compact_path
  #
  # removes trailing slashes, converts HOME to ~
  # TODO: interpolate '..'
  def compact_path
    sub(/ \/ \z/x, "").sub(/\A #{ENV['HOME']} /x, '~')
  end

  # :call-seq:
  # fully_qualified_path
  #
  # interpolates '..'
  # converts ~ to HOME
  # adds trailing slashes to directories
  def fully_qualified_path
    path = expand_path
    path = path.sub(/ \z/x, "/") if path.directory?
    path
  end
end
