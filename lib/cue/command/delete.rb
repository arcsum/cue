require 'cue/command/base'

module Cue
  module Command
    class Delete < Base
      def initialize(args)
        super(args)
        @sha = @args.first
      end
      
      def execute
        item_key = find_key(@sha)
        options.store.delete(item_key)
      end
      
      def nargs
        1
      end
    end
  end
end