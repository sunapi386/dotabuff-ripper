#!/usr/bin/env ruby
#https://github.com/bbatsov/ruby-style-guide

require 'nokogiri'
require 'open-uri'
require 'highline'

class ScrapeBot < HighLine

  def heros
    Nokogiri::HTML(open('http://dotabuff.com/heroes/')).
    css('div#container-content').
    css('a').
    collect do |link| 
      link['href'].sub(/^\/.*\//, '') if link['href'] =~ /^\/heroes\/.*$/
    end.compact!
  end

  def parse_row(tr)
    tds = tr.css('td') 
    name = tds[1].children[0].children[0].text.to_s
    advantage = tds[2].children[0].text.to_f
    winrate = tds[3].children[0].children.text.to_f
    matches = tds[4].children[0].children.text.sub(',','').to_i
    {:advantage => advantage, :name => name, :winrate => winrate, :matches => matches}
  end

  def matchups(hero)
    url = "http://dotabuff.com/heroes/#{hero}/matchups"
    Nokogiri::HTML(open(url)).css('tbody tr').collect{ |tr| parse_row(tr) }
  end

  def texas_am_chemistry
    page = Nokogiri::HTML(open('http://www.chem.tamu.edu/faculty/?bc2=academics'))
    people = page.css('#main-body #content p').drop(1)
    people.collect do |p|
      name = p.css('a')[0].text
      last_name = name.split(',')[0]
      email = p.css('a')[1].text
      [last_name, email]
    end
  end

  def run
    # matchups('lina')
    puts heros
  end
end

ScrapeBot.new.run


