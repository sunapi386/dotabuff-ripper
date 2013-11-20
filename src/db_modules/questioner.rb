module Questioner
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
        duals << [hero, (advantage + hero2_counters.select { |h, a| h == hero }[0][1]).round(2)]
      end
    end
    duals.sort_by! { |hero, advantage| advantage }
  end

  def all_heroes
    query = 'MATCH (n) RETURN collect(n.name)'
    @neo.execute_query(query)['data'][0][0]
  end
end