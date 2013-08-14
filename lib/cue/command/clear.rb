require 'cue/command/base'

module Cue
  module Command
    class Clear < Base      
      def execute
        options.store.clear
      end
    end
  end
end