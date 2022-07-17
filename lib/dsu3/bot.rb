# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'uri'

module DSU3
  class Bot
    API_BASE = 'https://discord.com/api/v9'

    # @param [Hash] headers
    def initialize(headers)
      @headers = headers
    end

    # Makes an API request, includes simple rate limit handling
    # @param [Symbol, String] method
    # @param [String] endpoint Discord API endpoint
    # @param [Hash] headers Additional request headers
    # @param [String] payload
    def request(method, endpoint, headers = {}, payload = nil)
      args = {
        method: method,
        url: URI.join(API_BASE, endpoint).to_s,
        headers: @headers.merge(headers)
      }

      args[:payload] = payload if payload

      begin
        RestClient::Request.execute(args)
      rescue RestClient::ExceptionWithResponse => e
        data = JSON.parse(e.response)

        if e.is_a?(RestClient::TooManyRequests)
          retry_after = data['retry_after'] / 1000.0

          LOGGER.warn("rate limit exceeded, waiting #{retry_after} seconds")
          sleep(retry_after)
          retry
        else
          LOGGER.error("#{data['code']}: #{data['message']}")
        end
      end
    end

    # Types text into a particular channel
    # @param [String, Integer] channel Channel ID
    def type(channel)
      request(:post, "channels/#{channel}/typing")
    end

    # Sends a message to a specific channel
    # @param [String, Integer] channel Channel ID
    # @param [String] message
    def send_message(channel, message)
      request(
        :post, "channels/#{channel}/messages",
        {}, { content: message }.to_json
      )
    end

    # Joins guild
    # @param [String] invite Invite code
    def join(invite)
      request(
        :post, "invites/#{invite}",
        { x_context_properties: 'eyJsb2NhdGlvbiI6Ik1hcmtkb3duIExpbmsifQ==' },
        '{}'
      )
    end

    # Reacts to a message
    # @note To use custom emoji, you must encode it in the format name:id with the emoji name and emoji id
    # @param [String, Integer] channel Channel ID
    # @param [String, Integer] message Message ID
    # @param [String] emoji
    def react(channel, message, emoji)
      emoji = URI.encode_www_form_component(emoji)

      request(
        :put,
        "channels/#{channel}/messages/#{message}/reactions/#{emoji}/@me",
        { params: { location: 'Message' } }
      )
    end
  end
end
