require 'cue/command/base'

module Cue
  module Command
    class Toggle < Base
      def initialize(args)
        super(args)
        @sha = @args.first
      end
      
      def execute
        find_item(@sha).tap do |item|
          item.toggle!
          item.save(options.store)
        end
      end
      
      def nargs
        1
      end
    end
  end
end