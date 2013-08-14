module Cue
  module Store
    class Memory
      def clear
        @store = {}
      end
      
      def delete(key)
        store.delete(key)
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
