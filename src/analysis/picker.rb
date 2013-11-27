require_relative '../../src/db/database'
require_relative '../../src/analysis/matching'
require 'highline/import'

def picker
  include Matching

  database_bot = DatabaseBot.new

# Lots of copy pasting code here, to-do: rework pasta

  puts 'Welcome to dota counter picker!'
  puts "Each time you enter a hero we summarize those heroes' worst enemies"

  hero1, counter1 = database_bot.prompt_user_for_hero
  puts "Counters to #{hero1}:"
  print_n_counters 10, counter1
  role1 = database_bot.role_of hero1
  summarize role1

  hero2, counter2 = database_bot.prompt_user_for_hero
  two_counters = merge_counters counter1, counter2
  puts "Counters to #{hero1}, and #{hero2}"
  print_n_counters 10, two_counters
  role2 = database_bot.role_of hero2
  summarize role1, role2

  hero3, counters3 = database_bot.prompt_user_for_hero
  three_counters = merge_counters two_counters, counters3
  puts "Counters to #{hero1}, #{hero2}, and #{hero3}:"
  print_n_counters 10, three_counters
  role3 = database_bot.role_of hero3
  summarize role1, role2, role3

  hero4, counters4 = database_bot.prompt_user_for_hero
  four_counters = merge_counters three_counters, counters4
  puts "Counters to #{hero1}, #{hero2}, #{hero3}, and #{hero4}:"
  print_n_counters 10, four_counters
  role4 = database_bot.role_of hero4
  summarize role1, role2, role3, role4

  hero5, counters5 = database_bot.prompt_user_for_hero
  five_counters = merge_counters four_counters, counters5
  puts "Counters to #{hero1}, #{hero2}, #{hero3}, #{hero4}, and #{hero5}:"
  print_n_counters 10, five_counters
  role5 = database_bot.role_of hero5
  summarize role1, role2, role3, role4, role5
  puts 'Done'

end




