class TimeWindowDropCollector
  module Wrappers
    class RailsCache
      attr_reader :client

      def initialize( opts )
        @client = Rails.cache
      end

      def incr( keys, expire_time, amount )
        TimeWindowDropCollector::Logger.log "RailsCache.incr( #{keys}, #{expire_time}, #{amount} )"

        keys.each do |key|
          client.write(key, 0, :raw => true, :unless_exist => true, expires_in: expire_time)
          client.increment( key, amount )
        end
      end

      def decr( keys, expire_time, amount )
        TimeWindowDropCollector::Logger.log "RailsCache.decr( #{keys}, #{expire_time}, #{amount} )"

        keys.each do |key|
          client.write(key, 0, :raw => true, :unless_exist => true, expires_in: expire_time)
          client.decrement( key, amount )
        end
      end

      def get( keys )
        client.read_multi( *keys, { :raw => true } )
      end

      def reset
        client.reset
      end
    end
  end
end

