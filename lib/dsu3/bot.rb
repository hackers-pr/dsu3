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
      rescue RestClient::TooManyRequests => e
        LOGGER.warn('rate limit exceeded')
        sleep(JSON.parse(e.response)['retry_after'] / 1000.0)
        retry
      end
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
  end
end
