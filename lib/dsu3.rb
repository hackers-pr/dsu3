# frozen_string_literal: true

require 'logger'
require 'dsu3/core'

# Main DSU3 namespace
module DSU3
  VERSION = '0.5.0'

  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::WARN
end
