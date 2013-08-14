require 'cue/command/base'

module Cue
  module Command
    class Show < Base
      def initialize(args)
        super(args)
        @sha = @args.first
      end
      
      def execute
        item = find_item(@sha)
        puts item
      end
      
      def nargs
        1
      end
    end
  end
end