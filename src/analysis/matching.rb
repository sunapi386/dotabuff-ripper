module Matching

  def summarize(*heroes_roles)
    frequencies = Hash.new(0)
    heroes_roles.each do |hero_roles|
      hero_roles.each do |role|
        frequencies[role] += 1
      end
    end
    frequencies.sort_by { |role, freq| freq }.reverse!
    frequencies.each { |role, freq| puts "#{freq} #{role}" }
    missing_roles = all_roles - frequencies.collect { |role, freq| role }
    puts "This team does not have: #{missing_roles.to_s}"
  end

  def search_amatch(hero)
    return 'No match' if hero.empty?
    m = LongestSubsequence.new hero
    relative_matches = all_heroes.zip(m.match all_heroes).sort_by { |hero, match| match }.reverse
    # Return heros of at least mostly matching, by distance
    relative_matches.collect { |hero, match| hero }.compact[0..5]
  end

  def all_roles
    ['Lane Support', 'Pusher', 'Carry', 'Disabler', 'Durable', 'Support', 'Escape', 'Initator', 'Jungler', 'Nuker']
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

end