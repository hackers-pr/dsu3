# frozen_string_literal: true

require './lib/dsu3/version'

Gem::Specification.new do |s|
  s.name = 'dsu3'
  s.version = DSU3::VERSION
  s.summary = 'a simple library for working with discord selfbots'
  s.files = Dir['lib/*', 'lib/**/*']
  s.extra_rdoc_files = ['README.md']
  s.author = 'Artur Sheremetjev IV'
  s.license = 'MIT'
  s.homepage = 'https://rubygems.org/gems/dsu3'
  s.metadata = {
    'source_code_uri' => 'https://github.com/hackers-pr/dsu3',
    'bug_tracker_uri' => 'https://github.com/hackers-pr/dsu3/issues',
    'wiki_uri' => 'https://www.rubydoc.info/gems/dsu3'
  }
  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'rest-client', '~> 2.0'
end
