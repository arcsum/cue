require 'cue/item'
require 'fileutils'
require 'zlib'

module Cue
  module Store
    class File
      include Enumerable
      
      def initialize(root_path=nil)
        @root_path = root_path
        FileUtils.mkdir_p(items_path)
      end
      
      def clear
        keys.each { |key| delete(key) }
      end
      
      def delete(key)
        FileUtils.rm_r(item_path(key))
        key_dir = dir_for(key)
        FileUtils.rm_r(key_dir) if Dir[::File.join(key_dir, '*')].empty?
      end
      
      def each
        items = keys.map(&method(:read)).sort
        yield(items)
      end
      
      def keys
        keys = []
        
        Dir.glob(::File.join(items_path, '*')).each do |prefix_dir|
          prefix = ::File.basename(prefix_dir)
          Dir.glob(::File.join(prefix_dir, '*')).each do |suffix_file|
            suffix = ::File.basename(suffix_file)
            keys << (prefix + suffix)
          end
        end
        
        keys
      end
      
      def read(key)
        return nil unless ::File.exists?(item_path(key))
        
        data = nil
        file_for_reading(item_path(key)) do |file|
          data = uncompress(file.read)
        end
        return data if data.nil?
        
        deserialize(data)
      end
      
      def write(key, item)
        FileUtils.mkdir_p(dir_for(key))
        file_for_writing(item_path(key)) do |file|
          data = compress(serialize(item))
          file.write(data)
        end
      end
      
      private
      
      def root_path
        @root_path ||= ::File.join(ENV['HOME'], '.cue')
      end
      
      def compress(data)
        Zlib::Deflate.deflate(data)
      end
      
      def deserialize(data)
        created_at, state, content = data.unpack('Z*Z*Z*')
        Cue::Item.new(content, created_at: created_at, state: state.to_sym)
      end
      
      def dir_for(key)
        ::File.join(items_path, prefix(key))
      end
      
      def file_for_writing(path, &block)
        ::File.open(path, mode_for_writing) { |file| yield(file) }
      end
      
      def file_for_reading(path, &block)
        ::File.open(path, mode_for_reading) { |file| yield(file) }
      end
      
      def item_path(key)
        ::File.join(dir_for(key), suffix(key))
      end
      
      def items_path
        @items_path ||= ::File.join(root_path, 'items')
      end
      
      def keys_path
        @keys_path ||= ::File.join(root_path, 'keys')
      end
      
      def mode_for_reading
        ::File::RDONLY
      end
      
      def mode_for_writing
        ::File::CREAT | ::File::WRONLY | ::File::TRUNC
      end
      
      def prefix(key)
        key[0..1]
      end
      
      def serialize(item)
        data = [item.created_at.to_i.to_s, item.state.to_s, item.content.to_s]
        data.pack('Z*Z*Z*')
      end
      
      def suffix(key)
        key[2...(key.size)]
      end
      
      def uncompress(data)
        Zlib::Inflate.inflate(data)
      end
    end
  end
end
