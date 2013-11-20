require_relative 'database'
require 'highline/import'

database_bot = DatabaseBot.new

puts 'Welcome to Dota counter-picker!'
puts '-------------------------------'
puts 'S - Single hero counters'
puts 'D - Dual hero counters'
puts 'A - All hero names'
puts 'F - Find a hero by partial name'
puts 'Q - Quit'

def sanitize(input)
  input.gsub(/[^0-9a-z]+/i, '').downcase.gsub(/( |'|-)/,'')
end


begin
  choice = sanitize ask 'Enter a choice: '

  case choice[0]
    when 's'
      hero = sanitize ask 'Enter Hero: '
      counters = database_bot.what_counters(hero)
      if counters.empty?
        puts 'Did you mean...'
        puts database_bot.search_regex(hero)
        puts  '...?'
      else
        counters[0..10].each { |hero, advantage| puts "#{hero} #{advantage}" }
      end

    when 'd'
      hero1 = sanitize ask 'Enter Hero 1: '
      hero2 = sanitize ask 'Enter Hero 2: '
      counters = database_bot.dual_counters(hero1, hero2)
      if counters.empty?
        puts 'Did you mean...'
        puts database_bot.search_regex(hero1)
        puts  '...or...'
        puts database_bot.search_regex(hero2)
        puts  '...?'
      else
        counters[0..10].each { |hero, advantage| puts "#{hero} #{advantage}" }
      end

    when 'a'
      puts database_bot.all_heroes

    when 'f'
      find_this = (ask 'Name: ').downcase.gsub(/[^0-9a-z]+/i, '')
      puts database_bot.search(find_this)

    when 'q'
      puts 'Goodbye!'
      exit!

    else
      puts 'Unknown choice!'
  end

end while true
