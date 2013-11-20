#!/usr/bin/env ruby
#http://docs.neo4j.org/refcard/2.0/
#http://docs.neo4j.org/chunked/milestone/query-create.html

require 'logger'
require 'neography'
require_relative 'scraper'

class DatabaseBot

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

  def compact_hero_name(hero)
    hero.downcase.gsub(/( |'|-)/,'')
  end

  def create_nodes(heroes)
    heroes.each do |hero|
      @log.info "Creating node for #{hero}"
      details = @scrapebot.hero_attributes(hero)
      properties = "{name:\"#{hero}\", role:\"#{details[:role]}\", popularity:#{details[:popularity]}, winrate:#{details[:winrate]}}"
      hero = compact_hero_name(hero)
      query = "CREATE (#{hero}:Hero:#{hero} #{properties});"
      @neo.execute_query query
    end
  end

  def create_relations(heroes)
    heroes.each do |hero|
      @log.info "Creating relations for #{hero}!"
      @scrapebot.matchups(hero).each do |opponent|
        hero = compact_hero_name(hero)
        opponent_name = compact_hero_name(opponent[:name])
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

  def create_graph_db
    @log.info 'GraphBot run'
    db_delete_all
    heroes = @scrapebot.heroes
    create_nodes(heroes)
    create_relations(heroes)
  end

  def advantage(from, to)
    @neo.execute_query("MATCH (n:#{from})-[r]->(m:#{to}) RETURN r.advantage")['data'][0][0]
  end

  def what_counters(hero)
    query = "MATCH (n:#{hero})-[r]->(m) WHERE r.advantage < 0 RETURN m.name, r.advantage ORDER BY r.advantage"
    @neo.execute_query(query)['data']
  end

  def dual_counters(hero1, hero2)
    # Probably a better way is to make a good query and let the graph db figure this out
    # Finds common heros that counters hero1 and hero2, and sums disadvantage
    duals = []
    hero1_counters = what_counters(hero1)
    hero2_counters = what_counters(hero2)
    hero2_counters_str = hero2_counters.to_s
    hero1_counters.each do |hero, advantage|
      if hero2_counters_str.include? hero
        duals << [hero, (advantage + hero2_counters.select{ |h, a| h == hero }[0][1]).round(2)]
      end
    end
    duals.sort_by! {|hero,advantage| advantage}
  end

end


