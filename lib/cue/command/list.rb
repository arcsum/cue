require 'cue'
require 'cue/command/base'

module Cue
  module Command
    class List < Base
      def execute
        options.store.each(&method(:puts))
      end
    end
  end
end