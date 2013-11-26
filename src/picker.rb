require_relative 'database'
require 'highline/import'

def sanitized_prompt(input)
  input.gsub(/[^a-z]+/i, '').downcase
end

def print_n_counters(n, hero_advantage_list)
  puts '-----------------------'
  hero_advantage_list[0..n].each do |hero, advantage|
    puts "#{hero} #{advantage}"
  end
  puts '-----------------------'
end


database_bot = DatabaseBot.new

# Lots of copy pasting code here, to-do: rework pasta

puts "Welcome to dota counter picker!"
puts "Each time you enter a hero we summarize those heroes' worst enemies"
hero1 = sanitized_prompt ask 'Hero 1 >>> '
hero1_counters = database_bot.nemesis_of hero1
while hero1_counters.empty?
  puts "Unrecognized hero '#{hero1}', similar names are..."
  puts database_bot.search_amatch hero1
  puts  '...'
  hero1 = sanitized_prompt ask 'Please re-enter Hero 1 >>> '
  hero1_counters = database_bot.nemesis_of hero1
end
puts "Counters to #{hero1}:"
print_n_counters 10, hero1_counters


hero2 = sanitized_prompt ask 'Hero 2 >>> '
hero2_counters = database_bot.nemesis_of hero2
while hero2_counters.empty?
  puts "Unrecognized hero '#{hero2}', similar names are..."
  puts database_bot.search_amatch hero2
  puts  '...'
  hero2 = sanitized_prompt ask 'Please re-enter Hero 2 >>> '
  hero2_counters = database_bot.nemesis_of hero2
end
two_counters = database_bot.merge_counters hero1_counters, hero2_counters
puts "Counters to #{hero1}, and #{hero2}:"
print_n_counters 10, two_counters


hero3 = sanitized_prompt ask 'Hero 3 >>> '
hero3_counters = database_bot.nemesis_of hero3
while hero3_counters.empty?
  puts "Unrecognized hero '#{hero3}', similar names are..."
  puts database_bot.search_amatch hero3
  puts  '...'
  hero3 = sanitized_prompt ask 'Please re-enter Hero 3 >>> '
  hero3_counters = database_bot.nemesis_of hero3
end
three_counters = database_bot.merge_counters two_counters, hero3_counters
puts "Counters to #{hero1}, #{hero2}, and #{hero3}:"
print_n_counters 10, three_counters


hero4 = sanitized_prompt ask 'Hero 4 >>> '
hero4_counters = database_bot.nemesis_of hero4
while hero4_counters.empty?
  puts "Unrecognized hero '#{hero4}', similar names are..."
  puts database_bot.search_amatch hero4
  puts  '...'
  hero4 = sanitized_prompt ask 'Please re-enter Hero 4 >>> '
  hero4_counters = database_bot.nemesis_of hero4
end
four_counters = database_bot.merge_counters three_counters, hero4_counters
puts "Counters to #{hero1}, #{hero2}, #{hero3}, and #{hero4}:"
print_n_counters 10, four_counters


hero5 = sanitized_prompt ask 'Hero 5 >>> '
hero5_counters = database_bot.nemesis_of hero5
while hero5_counters.empty?
  puts "Unrecognized hero '#{hero5}', similar names are..."
  puts database_bot.search_amatch hero5
  puts  '...'
  hero5 = sanitized_prompt ask 'Please re-enter Hero 5 >>> '
  hero5_counters = database_bot.nemesis_of hero5
end
five_counters = database_bot.merge_counters four_counters, hero5_counters
puts "Counters to #{hero1}, #{hero2}, #{hero3}, #{hero4}, and #{hero5}:"
print_n_counters 10, five_counters
roles = database_bot.role_of(hero1) + database_bot.role_of(hero2) + database_bot.role_of(hero3) + database_bot.role_of(hero4) + database_bot.role_of(hero5)
puts roles
puts 'Done'




