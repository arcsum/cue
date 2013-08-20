module Cue
  module Store
    class Memory
      include Enumerable
      
      def clear
        @store = {}
      end
      
      def delete(key)
        store.delete(key)
      end
      
      def each
        items = keys.map(&method(:read)).sort
        yield(items)
      end
      
      def keys
        store.keys
      end
      
      def read(key)
        store[key]
      end
      
      def write(key, item)
        store[key] = item.dup
      end
      
      private
      
      def store
        @store ||= {}
      end
    end
  end
end
