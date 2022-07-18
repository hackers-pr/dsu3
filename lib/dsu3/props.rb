# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'base64'

module DSU3
  module Props
    # user-agent header
    USER_AGENT =
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) '\
      'discord/0.0.18 Chrome/91.0.4472.164 Electron/13.6.6 Safari/537.36'

    # Decoded x-super-properties header
    SUPER_PROPERTIES = {
      os: 'Linux',
      browser: 'Discord Client',
      release_channel: 'stable',
      client_version: '0.0.18',
      os_version: '5.10.0-14-amd64',
      os_arch: 'x64',
      system_locale: 'en-US',
      window_manager: 'XFCE,xfce',
      distro: 'Debian GNU/Linux 11 (bullseye)',
      client_build_number: 136_921,
      client_event_source: nil
    }.freeze

    resp = RestClient.get('https://discord.com/api/v9/experiments')

    # Headers necessary for normal interaction with the Discord API
    HEADERS = {
      accept: '*/*',
      accept_encoding: 'gzip, deflate, br',
      accept_language: 'en-US',
      sec_fetch_dest: 'empty',
      sec_fetch_mode: 'cors',
      sec_fetch_site: 'same-origin',
      user_agent: USER_AGENT,
      x_debug_options: 'bugReporterEnabled',
      x_discord_locale: 'en-US',
      x_super_properties: Base64.strict_encode64(SUPER_PROPERTIES.to_json),
      content_type: 'application/json',
      origin: 'https://discord.com',
      cookie: HTTP::Cookie.cookie_value(resp.cookie_jar.cookies),
      x_fingerprint: JSON.parse(resp.body)['fingerprint']
    }.freeze
  end
end
