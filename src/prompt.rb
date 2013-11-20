require_relative 'database'
require 'highline/import'

database_bot = DatabaseBot.new

puts 'Welcome to Dota counter-picker!'
puts '-------------------------------'
puts 'W - Find single hero counters'
puts 'D - Find dual hero counters'
puts 'Q - Quit'
begin
  choice = (ask 'Enter a choice (W|D|Q): ').upcase!

  case choice
    when 'W'
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
    when 'Q'
      puts 'Goodbye!'
      exit!
    else
      puts 'Unknown choice!'
  end

end while true
