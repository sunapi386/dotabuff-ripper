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
begin
  choice = (ask 'Enter a choice: ').upcase.gsub(/[^0-9a-z]+/i, '')

  case choice[0]
    when 'S'
      hero = database_bot.compact_hero_name ask 'Enter Hero: '
      puts '-------------------------------'
      database_bot.what_counters(hero)[0..10].each do |hero, advantage|
        puts "#{hero} #{advantage}"
      end
    when 'D'
      hero1 = database_bot.compact_hero_name ask 'Enter Hero 1: '
      hero2 = database_bot.compact_hero_name ask 'Enter Hero 2: '
      puts '-------------------------------'
      database_bot.dual_counters(hero1, hero2)[0..10].each do |hero, advantage|
        puts "#{hero} #{advantage}"
      end
    when 'A'
      puts database_bot.all_heroes
    when 'F'
      find_this = (ask 'Name: ').downcase.gsub(/[^0-9a-z]+/i, '')
      database_bot.all_heroes.each do |name|
        puts name if name.include? find_this
      end
    when 'Q'
      puts 'Goodbye!'
      exit!
    else
      puts 'Unknown choice!'
  end

end while true
