#!/usr/bin/env ruby
#https://github.com/bbatsov/ruby-style-guide

require 'nokogiri'
require 'open-uri'
require 'logger'

class ScrapeBot

  XPATH_HERO_ROLE = '//*[@id="content-header-primary"]/div[2]/h1/small'
  XPATH_HERO_POPULARITY = '//*[@id="content-header-secondary"]/dl[1]/dd/div'
  XPATH_HERO_WINRATE = '//*[@id="content-header-secondary"]/dl[2]/dd/div'

  def initialize
    @log = Logger.new(STDERR)
    @log.level = Logger::INFO
  end

  def heroes
    Nokogiri::HTML(open('http://dotabuff.com/heroes/')).
        css('div#container-content').
        css('a').
        collect do |link|
      link['href'].sub(/^\/.*\//, '') if link['href'] =~ /^\/heroes\/.*$/
    end.compact!
  end

  def hero_attributes(hero)
    url = "http://dotabuff.com/heroes/#{hero}"
    page = Nokogiri::HTML(open(url))
    role = page.xpath(XPATH_HERO_ROLE)[0].children.text
    popularity = page.xpath(XPATH_HERO_POPULARITY)[0].children.text.to_i
    winrate = page.xpath(XPATH_HERO_WINRATE).children.children.text.to_f
    {:role => role, :popularity => popularity, :winrate => winrate}
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

  def heros_attributes
    heroes.collect do |hero|
      @log.info "Scraping #{hero} attributes"
      {:hero => hero, :hero_attributes => hero_attributes(hero)}
    end
  end

  def hero_matchups
    heroes.collect do |hero|
      @log.info "Scraping #{hero} matchups"
      {:hero => hero, :matchups => matchups(hero)}
    end
  end

end


