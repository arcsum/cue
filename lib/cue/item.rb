require 'colorfool'
require 'cue/indicator'
require 'digest'

module Cue
  class Item
    include ColorFool
    include Comparable
    
    attr_accessor :content
    attr_reader   :created_at, :state
    
    def initialize(content, attrs={})
      self.content = content
      
      attrs.each do |k, v|
        setter = "#{k}="
        if respond_to?(setter, true)
          send(setter, v)
        end
      end
      
      self.state = self.state || :incomplete
    end
    
    def <=>(other)
      created_at <=> other.created_at
    end
    
    def ==(other)
      content == other.content
    end
    
    def complete!
      self.state = :complete
    end
    
    def complete?
      self.state == :complete
    end
    
    def hash
      Digest::SHA1.hexdigest(content)
    end
    
    def in_store?(store)
      !store.read(hash).nil?
    end
    
    def incomplete!
      self.state = :incomplete
    end
    
    def incomplete?
      self.state == :incomplete
    end
    
    def save(store)
      self.created_at = Time.now unless in_store?(store)
      store.write(hash, self)
    end
    
    def to_s
      i = Indicator.new(state)
      h = colorize(:cyan) { hash[0..6] }
      "#{h} #{i} #{content}"
    end
    
    def toggle!
      complete? ? incomplete! : complete!
      self
    end
    
    private
    
    attr_writer :created_at, :state
  end
end
