require 'forwardable'

module Cue
  class Group
    extend Forwardable
    
    def_delegators :items, :<<, :[], :each, :size
    
    def items
      @items ||= []
    end
    
    def to_s
      items.map(&:to_s).join("\n")
    end
  end
end
