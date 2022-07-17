# frozen_string_literal: true

require 'dsu3/props'
require 'dsu3/bot'

module DSU3
  # All DSU3 functionality, used to manage multiple bots
  class Core
    # @param [Array] tokens List of bot tokens
    def initialize(tokens)
      headers = Props.headers
      @bots = tokens.map { |token| Bot.new(headers.merge(authorization: token)) }
    end

    # (see Bot#type)
    def typespam(channel)
      loop do
        @bots.each { |bot| bot.type(channel) }
        sleep 9
      end
    end

    # (see Bot#send_message)
    def send_message(channel, message)
      @bots.each { |bot| bot.send_message(channel, message) }
    end

    # Infinitely calls a block and sends the value it returns to a specific channel
    # @param [String, Integer] channel Channel ID
    def spam(channel, &block)
      loop { @bots.each { |bot| bot.send_message(channel, block.call) } }
    end

    # (see Bot#join)
    def join(invite)
      @bots.each do |bot|
        bot.join(invite)
        sleep(0.5)
      end
    end

    # (see Bot#react)
    def react(channel, message, emoji)
      @bots.each { |bot| bot.react(channel, message, emoji) }
    end
  end
end
