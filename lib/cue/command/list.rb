require 'cue'
require 'cue/command/base'

module Cue
  module Command
    class List < Base
      def execute
        Cue.items_for_store(options.store).each { |item| puts item }
      end
    end
  end
end