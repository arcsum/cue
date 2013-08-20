require 'cue/item'
require 'redis'
require 'time'

module Cue
  module Store
    class Redis
      include Enumerable
      
      class << self
        attr_writer :namespace, :redis
        
        def configure(&block)
          self.tap { |klass| yield(klass) }
        end
        
        def namespace
          @namespace ||= 'cue'
        end
        
        def redis
          @redis ||= ::Redis.new
        end
      end
      
      def clear
        item_keys = redis.smembers(redis_key('keys'))
        keys_key  = redis_key('keys')
        
        redis.del(item_keys, keys_key)
      end
      
      def delete(key)
        item_key = item_key(key)
        
        redis.del(item_key)
        redis.srem(redis_key('keys'), item_key)
      end
      
      def each
        items = keys.map(&method(:read)).sort
        yield(items)
      end
      
      def keys
        redis.smembers(redis_key('keys')).map do |redis_key|
          redis_key.split(':').last
        end
      end
      
      def read(key)
        item_hash = redis.hgetall(item_key(key))
        return nil if item_hash.empty?
        
        deserialize(item_hash)
      end
      
      def write(key, item)
        add_key(key)
        add_item(key, item)
      end
      
      private
      
      def add_item(key, item)
        redis.mapped_hmset(item_key(key), serialize(item))
      end
      
      def add_key(key)
        redis.sadd(redis_key('keys'), item_key(key))
      end
      
      def deserialize(item_hash)
        content    = item_hash['content']
        created_at = Time.parse(item_hash['created_at']) if item_hash['created_at']
        state      = item_hash['state'].to_sym
        
        Cue::Item.new(content, created_at: created_at, state: state)
      end
      
      def item_key(key)
        redis_key('item', key)
      end
      
      def namespace
        self.class.namespace
      end
      
      def redis
        self.class.redis
      end
      
      def redis_key(*components)
        key = *components
        key.unshift(namespace)
        
        key.join(':')
      end
      
      def serialize(item)
        {
          'state'      => item.state.to_s,
          'content'    => item.content
        }.tap do |hash|
          hash['created_at'] = item.created_at.to_s if item.created_at
        end
      end
    end
  end
end
