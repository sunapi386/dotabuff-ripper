require_relative 'database'
require 'highline/import'

database_bot = DatabaseBot.new

def prompt_menu
  puts
  puts 'Welcome to Dota counter-picker!'
  puts '-------------------------------'
  puts 's - Single hero counters'
  puts 'd - Dual hero counters'
  puts 'a - All hero names'
  puts 'f - Find a hero by partial name'
  puts 'q - Quit'
  puts '-------------------------------'
end

def sanitize(input)
  input.gsub(/[^a-z]+/i, '').downcase
end

def print_n_counters(n, hero_advantage_list)
  hero_advantage_list[0..n].each do |hero, advantage|
    puts "#{hero} #{advantage}"
  end
end

prompt_menu
while true
  choice = sanitize ask '>>> '

  case choice[0]
    when 's'
      hero = sanitize ask 'Hero: '
      counters = database_bot.what_counters hero
      if counters.empty?
        puts 'Did you mean...'
        puts database_bot.search_amatch hero
        puts  '...?'
      else
        print_n_counters 10, counters
      end

    when 'd'
      hero1 = sanitize ask 'Hero 1: '
      hero2 = sanitize ask 'Hero 2: '
      hero1_counters = database_bot.what_counters(hero1)
      hero2_counters = database_bot.what_counters(hero2)
      counters = database_bot.merge_counters(hero1_counters, hero2_counters)
      if counters.empty?
        puts 'Did you mean...'
        puts database_bot.search_amatch hero1
        puts  "... for #{hero1}, and for #{hero2}..."
        puts database_bot.search_amatch hero2
        puts  '...?'
      else
        print_n_counters 10, counters
      end

    when 'a'
      puts '----All heros---------'
      puts database_bot.all_heroes

    when 'f'
      find_this = sanitize ask 'Name: '
      puts 'Similar hero names...'
      puts database_bot.search_amatch find_this

    when 'q'
      puts 'Goodbye!'
      exit!

    else
      puts 'Unknown choice!'
      prompt_menu
  end

end
