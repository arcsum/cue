require 'cue/store/redis'
require 'json'
require 'ostruct'
require 'optparse'

module Cue
  module Command
    class Base
      attr_reader :options
      
      def initialize(args)
        @options = OpenStruct.new.tap do |opts|
          opts.store = Cue::Store::Redis.new
        end
        
        @args = parser.parse(args)
        configure_store
        check_num_arguments
      end
      
      def find_key(key_prefix)
        keys     = options.store.keys
        item_ids = keys.select { |id| id.start_with?(key_prefix) }
        
        if item_ids.size > 1
          parser.abort "#{key_prefix} is too ambiguous."
        end
        
        item_id = item_ids.first
        
        parser.abort("Couldn't find item #{key_prefix}.") unless item_id
        item_id
      end
      
      def find_item(key_prefix)
        options.store.read(find_key(key_prefix))
      end
      
      def nargs
        0
      end
      
      def parser
        @parser ||= OptionParser.new do |opts|
          opts.banner = "Usage: #{File.basename($0)} [options]"
          
          opts.on('-s', '--store [STORE]', 'Specify the store adapter') do |store|
            begin
              require "cue/store/#{store}"
              klass = store.split('_').map(&:capitalize).join
              options.store = Cue.const_get("Store::#{klass}").new
            rescue LoadError
              opts.abort "Couldn't find the store adapter \"#{store}\"."
            end
          end
        end
      end
      
      private
      
      def check_num_arguments
        case nargs
        when Range
          parser.abort('Invalid number of arguments.') unless nargs.cover?(@args.size)
        else
          parser.abort('Invalid number of arguments.') if @args.size != nargs
        end
      end
      
      def config_path
        File.join(ENV['HOME'], '.cue', 'config.json')
      end
      
      def configure_redis
        get_config(:redis) do |config|
          Cue::Store::Redis.configure do |rconfig|
            opts = config.select { |k,_| [:host, :port, :password].include?(k) }
            rconfig.redis = Redis.new(opts)
          end
        end
      end
      
      def configure_store
        case options.store
        when Cue::Store::Redis
          configure_redis
        end
      end
      
      def get_config(key=nil, &block)
        return unless File.exists?(config_path)
        
        json = JSON.parse(File.read(config_path), symbolize_names: true)
        key.nil? ? yield(json) : yield(json[key])
      end
    end
  end
end
