require 'amatch'

module Questioner
  include Amatch

  def advantage(from, to)
    @neo.execute_query("MATCH (n:#{from})-[r]->(m:#{to}) RETURN r.advantage")['data'][0][0]
  end

  def what_counters(hero)
    query = "MATCH (n:#{hero})-[r]->(m) WHERE r.advantage < 0 RETURN m.name, r.advantage ORDER BY r.advantage"
    @neo.execute_query(query)['data']
  end

  def merge_counters(hero1_counters, hero2_counters)
    duals = []
    hero2_counters_str = hero2_counters.collect { |h, a| h }.sort.to_s
    hero1_counters.each do |hero, disadvantage|
      disadvantage_hero2 = hero2_counters.select { |h, a| h == hero }
      if hero2_counters_str.include?(hero) && !disadvantage_hero2.empty?
        duals << [hero, (disadvantage + disadvantage_hero2[0][1]).round(2) ]
      end
    end
    duals.sort_by { |hero, advantage| advantage }
  end

  def all_heroes
    query = 'MATCH (n) RETURN collect(n.name)'
    @neo.execute_query(query)['data'][0][0]
  end

  def search_amatch(hero)
    return 'No match' if hero.empty?
    m = LongestSubsequence.new hero
    relative_matches = all_heroes.zip(m.match all_heroes).sort_by { |hero, match| match }.reverse
    # Return heros of at least mostly matching, by distance
    relative_matches.collect { |hero, match| hero }.compact[0..5]
  end

end