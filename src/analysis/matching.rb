require 'amatch'

module Matching
  include Amatch

  def all_roles
    ['Lane Support', 'Pusher', 'Carry', 'Disabler', 'Durable', 'Support', 'Escape', 'Initator', 'Jungler', 'Nuker']
  end

  def merge_counters(hero1_counters, hero2_counters)
    duals = []
    hero2_counters_str = hero2_counters.collect { |h, _| h }.sort.to_s
    hero1_counters.each do |hero, disadvantage|
      disadvantage_hero2 = hero2_counters.select { |h, _| h == hero }
      if hero2_counters_str.include?(hero) && !disadvantage_hero2.empty?
        duals << [hero, (disadvantage + disadvantage_hero2[0][1]).round(2) ]
      end
    end
    duals.sort_by { |_, advantage| advantage }
  end

  def print_n_counters(n, hero_advantage_list)
    puts '-----------------------'
    hero_advantage_list[0..n].each do |hero, advantage|
      puts "#{hero} #{advantage}"
    end
    puts '-----------------------'
  end

  def search_amatch(keyword)
    return 'No match' if keyword.empty?
    m = LongestSubsequence.new keyword
    relative_matches = all_heroes.zip(m.match all_heroes).sort_by { |_, match| match }.reverse
    # Return heros of at least mostly matching, by distance
    relative_matches.collect { |hero, _| hero }.compact[0..5]
  end

  def summarize(*heroes_roles)
    frequencies = Hash.new(0)
    heroes_roles.each do |hero_roles|
      hero_roles.each do |role|
        frequencies[role] += 1
      end
    end
    frequencies.sort_by { |_, freq| freq }.reverse!
    frequencies.each { |role, freq| puts "#{freq} #{role}" }
    missing_roles = all_roles - frequencies.collect { |role, _| role }
    puts "This team does not have: #{missing_roles.to_s}"
  end

end