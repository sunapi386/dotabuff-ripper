

module Questioner


  def advantage(from, to)
    @neo.execute_query("MATCH (n:#{from})-[r]->(m:#{to}) RETURN r.advantage")['data'][0][0]
  end

  def nemesis_of(hero)
    query = "MATCH (n:#{hero})-[r]->(m) WHERE r.advantage < 0 RETURN m.name, r.advantage ORDER BY r.advantage"
    @neo.execute_query(query)['data']
  end

  def role_of(hero)
    query = "MATCH (n:#{hero}) RETURN n.role"
    @neo.execute_query(query)['data'][0][0].split(', ')
  end

  def all_heroes
    query = 'MATCH (n) RETURN collect(n.name)'
    @neo.execute_query(query)['data'][0][0]
  end

  def sanitized_prompt(input)
    input.gsub(/[^a-z]+/i, '').downcase
  end

  def prompt_user_for_hero
    hero = sanitized_prompt ask 'Hero >>> '
    counters = nemesis_of hero
    while hero.empty? || counters.empty?
      puts "Unrecognized hero '#{hero}', similar names are..."
      puts search_amatch hero
      puts  '...'
      hero = sanitized_prompt ask 'Please re-enter Hero >>> '
      counters = nemesis_of hero
    end
    [hero, counters]
  end


end