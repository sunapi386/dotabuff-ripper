

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
    begin
    hero = sanitized_prompt ask '>>> '
    end while hero.empty?
    counters = nemesis_of hero
    while counters.empty?
      similar = search_amatch hero
      puts "#{hero} is unknown. Similar names are..."
      puts similar
      puts "Enter if you want #{similar.first}"
      hero = sanitized_prompt ask '>>> '
      hero = similar.first if hero.empty?
      counters = nemesis_of hero
    end
    [hero, counters]
  end


end