# frozen_string_literal: true

require 'rest-client'
require 'uri'

module DSU3
  class Bot
    API_BASE = 'https://discord.com/api/v9'

    def initialize(headers)
      @headers = headers
    end

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
        sleep(e.headers['Retry-After'])
        retry
      end
    end
  end
end
