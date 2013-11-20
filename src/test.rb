require_relative 'database'


database_bot = DatabaseBot.new

#database_bot.create_graph_db
#puts database_bot.advantage('lina','lion')
#database_bot.what_counters('lina').each { |hero, advantage| puts "#{hero} #{advantage}"}
database_bot.dual_counters('lina', 'lion').each {|hero, advantage| puts "#{hero} #{advantage}"}
