require 'tempfile'

module Cue
  module Command
    module Utils
      class Editor
        def basename
          'cue'
        end
        
        def command
          ENV['EDITOR'] || default_editor
        end
        
        def read
          Process.wait(spawn([command, path].join(' ')))
          content = File.read(path)
          
          File.delete(path)
          
          content
        end
        
        def dir
          '/tmp'
        end
        
        def path
          @path ||= File.expand_path(Dir::Tmpname::make_tmpname(basename, nil), dir)
        end
        
        private
        
        def default_editor
          'vi'
        end
      end
    end
  end
end
