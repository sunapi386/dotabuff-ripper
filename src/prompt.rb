require_relative 'db/database'
require_relative 'analysis/picker'
require 'highline/import'


def show_choices
  puts
  puts 'Welcome to Dota counter-picker!'
  puts '-------------------------------'
  puts 's - Single hero counters'
  puts 't - Team hero counters'
  puts 'a - All hero names'
  puts 'f - Find a hero by partial name'
  puts 'q - Quit'
  puts '-------------------------------'
end

def sanitize(input)
  input.gsub(/[^a-z]+/i, '').downcase
end

def promptAndGet(prompt)
  input = sanitize ask "#{prompt} >>> "
end

def menu
  show_choices
  while true
    choice = promptAndGet 'Choice'

    case choice[0]
      when 's'
        puts '-----Single hero------'
        hero = promptAndGet 'Hero'
        counters = database_bot.nemesis_of hero
        if counters.empty?
          puts 'Did you mean...'
          puts database_bot.search_amatch hero
          puts  '...?'
        else
          print_n_counters 10, counters
        end

      when 't'
        puts '-----Team picker------'
        picker

      when 'a'
        puts '----All heros---------'
        puts database_bot.all_heroes

      when 'f'
        puts '-----Find hero--------'
        find_this = promptAndGet 'Name'
        puts 'Similar hero names...'
        puts database_bot.search_amatch find_this

      when 'q'
        puts 'Goodbye!'
        exit!

      else
        puts 'Unknown choice!'
        show_choices
    end

  end
end

database_bot = DatabaseBot.new
menu
