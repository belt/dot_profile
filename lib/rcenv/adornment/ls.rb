require 'configuration'

module RCEnv
  module Adornment
    # chooses ls colors
    # sets LS_COLORS or LSCOLORS based on OSTYPE
    #
    # TODO: ponder an LS-COLORS "api" for assigning colors
    class Ls
      attr_accessor :alias_ls, :ls_colors

      def initialize(conf = {})
        @options = conf
        @color_code = nil
        @extensions = nil
        auto_ls_colors
        process_options
      end

      def to_sh
        sh = "alias ls=\"ls #{@alias_ls}\"\n"
        unless @ls_colors.match(/\A\s+\z/x)
          sh += "#{@ls_colors_var}=\"#{@ls_colors}\"; export #{@ls_colors_var}\n"
        end
        sh
      end

      # :: BSD LSCOLORS SCHEME
      # a     black         b     red
      # c     green         d     brown
      # e     blue          f     magenta
      # g     cyan          h     light grey
      # A     bold black (usually shows up as dark grey)
      # B     bold red      C     bold green
      # D     bold brown (usually shows up as yellow)
      # E     bold blue     F     bold magenta
      # G     bold cyan
      # H     bold light grey (looks like bright white)
      # x     default foreground or background
      #
      # directory, symbolic link, socket, pipe, executable, block special,
      # character special, executable with setuid bit set,
      # executable with setgid bit set, directory writable to others,
      # with sticky bit, directory writable to others, without sticky bit
      #
      # ls_colors[:default_darwin] = 'exfxcxdxbxegedabagacad'

      LS_COLORS_VAR = {
        darwin: 'LSCOLORS', linux: 'LS_COLORS',
        default: 'LS_COLORS'
      }

      LS_COLORS_OPT = {
        darwin: '-FG', linux: '--color=autho -F',
        default: '-F'
      }

      # TODO: sync darwin colors with everyone elses
      def auto_ls_colors
        hosttype = ENV['DOTBASH_OSTYPE'] || ENV['RC_OSTYPE'] || ENV['OSTYPE']
        hosttype = hosttype ? hosttype.to_sym : :default
        sys_var = LS_COLORS_VAR.key?(hosttype) ? hosttype : :default
        @ls_colors_var = LS_COLORS_VAR[sys_var]
        @alias_ls = LS_COLORS_OPT[sys_var]

        ls_colors = {
          darwin: 'gxgxfxfxcxegedabagacad', linux: linux_colors,
          default: ''
        }

        @ls_colors = ls_colors[sys_var]
      end

      protected

      def process_options
        @alias_ls = alias_ls? ? @options[:alias_ls] : @alias_ls
        @ls_colors = ls_colors? ? @options[:ls_colors] : @ls_colors
      end

      def alias_ls?
        @options.key?(:alias_ls)
      end

      def ls_colors?
        @options.key?(:ls_colors)
      end

      def color_code_files
        @extensions.map { |ext|"#{@color_code}:*.#{ext}=00" }.join(';') + ';'
      end

      # ----------------------------------------------------------------------
      # linux colors
      #
      # TODO: sync linux colors with everyone elses (ansi?)
      # TODO: lookup linux key codes, and point to source of docs
      def linux_colors
        linux_misc + linux_shells + linux_images + linux_archives +
          linux_compression + linux_packages + linux_default
      end

      def linux_misc
        'no=00:fi=00:di=00;36:pi=40;36:ln=00;33:so=00;35:bd=40;33;' \
        '01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;'
      end

      def linux_shells
        @color_code = 32
        @extensions = %w(sh csh zsh cmd bat com exe)
        color_code_files
      end

      def linux_archives
        @color_code = 32
        @extensions = %w(cpio tar)
        color_code_files
      end

      def linux_compression
        @color_code = 31
        @extensions = %w(tbz2 bz2 bz tgz gz tz z Z lhz arj rar zip)
        color_code_files
      end

      def linux_images
        @color_code = 35
        @extensions = %w(jpg gif bmp png tif xmb xpm)
        color_code_files
      end

      def linux_packages
        @color_code = 31
        @extensions = %w(rpm deb pac)
        color_code_files
      end

      def linux_default
        @extensions = %w()
        @color_code = '35:'
      end
    end
  end
end
