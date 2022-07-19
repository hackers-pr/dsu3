# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'uri'

module DSU3
  # Class representing Discord bot
  class Bot
    API_BASE = 'https://discord.com/api/v9'

    # @param [String] token Discord account token
    # @param [Array] proxies List of proxy servers
    #   If the list of proxy servers is empty, the proxy will not be used
    def initialize(token, proxies = [])
      @headers = Props::HEADERS.merge(authorization: token)
      @proxies = proxies
    end

    # Makes an API request without any error handling
    # @param [Symbol, String] method
    # @param [String] endpoint Discord API endpoint
    # @param [Hash] headers Additional request headers
    # @param [String] payload
    def raw_request(method, endpoint, headers = {}, payload = nil)
      RestClient::Request.execute(
        method: method,
        url: URI.join(API_BASE, endpoint).to_s,
        headers: @headers.merge(headers),
        payload: payload,
        proxy: @proxies.sample
      )
    end

    # Makes an API request, includes simple error handling
    # @param (see #raw_request)
    def request(...)
      raw_request(...)
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

    # Types text into a particular channel
    # @param [String, Integer] channel Channel ID
    def type(channel)
      request(:post, "channels/#{channel}/typing")
    end

    # Sends a message to a specific channel
    # @param [String, Integer] channel Channel ID
    # @param [String] message Message ID
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
