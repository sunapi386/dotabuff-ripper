#!/usr/bin/env ruby
#http://docs.neo4j.org/refcard/2.0/
#http://docs.neo4j.org/chunked/milestone/query-create.html

require 'logger'
require 'neography'
require_relative 'scraper'
require_relative 'db/creator'
require_relative 'db/questioner'

class DatabaseBot
  include Creator
  include Questioner

  def initialize
    Neography.configure do |config|
      config.protocol       = 'http://'
      config.server         = 'localhost'
      config.port           = 7474
      config.max_threads    = 20
      config.parser         = MultiJsonParser
    end
    @neo = Neography::Rest.new
    @log = Logger.new(STDERR)
    @log.level = Logger::INFO
    @scrapebot = ScrapeBot.new
  end

end


