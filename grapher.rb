#!/usr/bin/env ruby
#https://github.com/bbatsov/ruby-style-guide

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
    @nodes = []
    @scrapebot = ScrapeBot.new
  end

  def count_edges
    edges_query = 'START r=rel(*) RETURN count(r)'
    q_relations = @neo.execute_query edges_query
    @log.info "#{q_relations['data'][0][0]} relations"
    q_relations['data'][0][0]
  end

  def count_nodes
    nodes_query = 'START n=node(*) RETURN count(n)'
    q_nodes = @neo.execute_query nodes_query
    @log.info "#{q_nodes['data'][0][0]} nodes"
    q_nodes['data'][0][0]
  end

  def db_delete_all
    db_delete_all_query = 'START n=node(*) MATCH n-[r?]-() WHERE ID(n) <> 0 DELETE n,r'
    @neo.execute_query db_delete_all_query
    @log.warn 'Neo4j database cleared'
  end

  def retrieve_node(name)
    @log.debug "Retrieve #{name}"
    find_query = "MATCH (x:Hero) WHERE x.name = \"#{name}\" RETURN x;"
    @neo.execute_query find_query
  end

  def get_node_id(name)
    @log.debug "Node id #{name}"
    node = retrieve_node(name)
    url = node['data'][0][0]['self']
    url.match(/\d+$/).to_s.to_i # to_s then to_i is necessary
  end

  def format_name(hero)
    hero.downcase.gsub(/( |'|-)/,'')
  end

  def create_nodes(heroes)
    heroes.each do |hero|
      @log.info "Creating node for #{hero}"
      query = "CREATE (#{format_name(hero)}:Hero:#{format_name(hero)} {name:\"#{hero}\"});"
      @neo.execute_query query
    end
  end


  def create_relations(heroes)
    heroes.each do |hero|
      @log.info "Creating relations for #{hero}!"
      @scrapebot.matchups(hero).each do |opponent|
        hero = format_name(hero)
        opponent_name = format_name(opponent[:name])
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

  def read_file(file)
    f = File.new(file)
    arr = []
    while !f.eof?
      line = f.readline.gsub("\n",'')
      arr << line.to_s
    end
    arr
  end

  def run
    @log.info 'GraphBot run'
    db_delete_all
    #heroes = @scrapebot.heroes
    heroes = read_file('heros.txt')
    create_nodes(heroes)
    create_relations(heroes)
  end

end

#graphBot = GraphBot.new
#graphBot.count_nodes
#graphBot.count_edges
#graphBot.db_delete_all
#graphBot.count_nodes
#graphBot.count_edges

GraphBot.new.run
