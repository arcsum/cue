require 'colorfool'

module Cue
  class Indicator
    include ColorFool
    
    attr_reader :state
    
    def initialize(state)
      @state = state
    end
    
    def color
      case state
      when :complete
        :green
      when :incomplete
        :red
      else
        :none
      end
    end
    
    def symbol
      case state
      when :complete
        '✓'
      when :incomplete
        '✗'
      else
        '?'
      end
    end
    
    def to_s
      colorize(color) { symbol }
    end
  end
end