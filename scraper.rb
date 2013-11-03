#!/usr/bin/env ruby
#https://github.com/bbatsov/ruby-style-guide

require 'nokogiri'
require 'open-uri'
require 'highline'

class ScrapeBot < HighLine

  def heros # I don't like heroes spelling.
    Nokogiri::HTML(open('http://dotabuff.com/heroes/')).
    css('div#container-content').
    css('a').
    collect do |link| 
      link['href'].sub(/^\/.*\//, '') if link['href'] =~ /^\/heroes\/.*$/
    end.compact!
  end

  def matchups(hero)
    url = "http://dotabuff.com/heroes/#{hero}/matchups"
    page = Nokogiri::HTML(open(url))
    page.css('tbody tr').collect do |row|
      cells = row.css('td') 
      name = cells[1].children[0].children[0].text.to_s
      advantage = cells[2].children[0].text.to_f
      winrate = cells[3].children[0].children.text.to_f
      matches = cells[4].children[0].children.text.sub(',','').to_i
      {:advantage => advantage, :winrate => winrate, :matches => matches, :name => name}
    end
  end



  def run
    puts matchups('lina')
    # puts heros
  end
end

ScrapeBot.new.run


