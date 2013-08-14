require 'cue/command/base'
require 'cue/command/utils/editor'

module Cue
  module Command
    class Add < Base
      def initialize(args)
        super(args)
        
        if @args.size == 1
          @content = @args.first
        else
          @content = Utils::Editor.new.read
        end
      end
      
      def execute
        item = Cue::Item.new(@content)
        item.save(options.store)
      end
      
      def nargs
        (0..1)
      end
    end
  end
end