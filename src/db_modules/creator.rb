module Creator
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

end