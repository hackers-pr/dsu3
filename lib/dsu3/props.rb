# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'base64'

module DSU3
  # The fundamental class in this vast system, on which all the other parts of the structure depend
  module Props
    # user-agent header
    USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0'

    DATAMINING_COMMITS_URL = 'https://api.github.com/repos/Discord-Datamining/Discord-Datamining/commits/master'

    # Fetches Discord client build number
    def self.fetch_build_number
      JSON.parse(RestClient.get(DATAMINING_COMMITS_URL))['commit']['message'].match(/Build (\d+)/)[1]
    end

    # Decoded x-super-properties header
    SUPER_PROPERTIES = {
      os: 'Linux',
      browser: 'Firefox',
      device: '',
      system_locale: 'en',
      browser_user_agent: USER_AGENT,
      browser_version: '91.0',
      os_version: '',
      referrer: '',
      referring_domain: '',
      referrer_current: '',
      referring_domain_current: '',
      release_channel: 'stable',
      client_build_number: fetch_build_number,
      client_event_source: nil
    }.freeze

    resp = RestClient.get('https://discord.com/api/v9/experiments')

    # Headers necessary for normal interaction with the Discord API
    HEADERS = {
      accept: '*/*',
      accept_encoding: 'gzip, deflate, br',
      accept_language: 'en',
      alt_used: 'discord.com',
      connection: 'keep-alive',
      host: 'discord.com',
      sec_fetch_dest: 'empty',
      sec_fetch_mode: 'cors',
      sec_fetch_site: 'same-origin',
      te: 'trailers',
      user_agent: USER_AGENT,
      x_debug_options: 'bugReporterEnabled',
      x_discord_locale: 'en-US',
      x_super_properties: Base64.strict_encode64(SUPER_PROPERTIES.to_json),
      content_type: 'application/json',
      cookie: HTTP::Cookie.cookie_value(resp.cookie_jar.cookies),
      x_fingerprint: JSON.parse(resp.body)['fingerprint']
    }.freeze
  end
end
