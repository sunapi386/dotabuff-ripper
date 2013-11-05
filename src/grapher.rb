#!/usr/bin/env ruby
#http://docs.neo4j.org/refcard/2.0/
#http://docs.neo4j.org/chunked/milestone/query-create.html

require 'logger'
require 'neography'
require_relative 'scraper'

class GraphBot

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

  def db_delete_all
    db_delete_all_query = 'START n=node(*) MATCH n-[r?]-() WHERE ID(n) <> 0 DELETE n,r'
    @neo.execute_query db_delete_all_query
    @log.warn 'Neo4j database cleared'
  end

  def query_format_name(hero)
    hero.downcase.gsub(/( |'|-)/,'')
  end

  def create_nodes(heroes)
    heroes.each do |hero|
      @log.info "Creating node for #{hero}"
      details = @scrapebot.more(hero)
      properties = "{name:\"#{hero}\", role:\"#{details[:role]}\", popularity:#{details[:popularity]}, winrate:#{details[:winrate]}}"
      hero = query_format_name(hero)
      query = "CREATE (#{hero}:Hero:#{hero} #{properties});"
      @neo.execute_query query
    end
  end

  def create_relations(heroes)
    heroes.each do |hero|
      @log.info "Creating relations for #{hero}!"
      @scrapebot.matchups(hero).each do |opponent|
        hero = query_format_name(hero)
        opponent_name = query_format_name(opponent[:name])
        properties = "advantage: #{opponent[:advantage]}, winrate: #{opponent[:winrate]}, matches: #{opponent[:matches]}"
        query = "MATCH (current:Hero), (opponent:Hero)\n" +
                "WHERE current.name = '#{hero}' AND opponent.name = '#{opponent_name}'\n" +
                "CREATE (current)-[r:DATA {#{properties}}]->(opponent);"
        @neo.execute_query query
        @log.debug "Created (#{hero})->(#{opponent_name})!"
      end
    end
    @log.info 'Done creating relations!'
  end

  def create_graph
    @log.info 'GraphBot run'
    db_delete_all
    heroes = @scrapebot.heroes
    create_nodes(heroes)
    create_relations(heroes)
  end

end

GraphBot.new.create_graph
