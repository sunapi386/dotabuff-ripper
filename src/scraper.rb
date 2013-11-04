#!/usr/bin/env ruby
#https://github.com/bbatsov/ruby-style-guide

require 'nokogiri'
require 'open-uri'
require 'logger'

class ScrapeBot

  def initialize
    @log = Logger.new(STDERR)
    @log.level = Logger::INFO
    @log.info "ScrapeBot initialize"
  end

  def heroes
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
    heroes.collect do |hero|
      @log.info "Scraping #{hero}"
      {:hero => hero, :matchups => matchups(hero)}
    end
  end
end

#puts ScrapeBot.new.run


