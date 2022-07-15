# frozen_string_literal: true

require 'logger'
require 'dsu3/core'

module DSU3
  VERSION = '0.1.0'

  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::WARN
end
