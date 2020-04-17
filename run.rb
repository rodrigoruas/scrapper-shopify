require 'thread/pool'
require 'httparty'
require 'csv'
require "open-uri"
require_relative 'methods'

data_file = "part1.csv"

puts "Open CSV file"
@links = get_urls_from_csv(data_file)
puts "#{@links.count} links founded"
@french_links = []

# pool = Thread.pool(500)
puts "Reading links..."
@links.first(1000).each_with_index do |link, index|
  url = "http://#{link}"
  # pool.process {
    begin
      response = HTTParty.get(url)
      if((response.body.include?('lang="fr"')) || (response.body.include?('"contentLanguage"="fr"')))
        print 'Allez les bleus!'
        create_html_file(url)
      end
      p "Success!"
    rescue => e
      p e
    end
     # sleep(1)
  # }
 end
# pool.shutdown

puts "Exporting french links to CSV..."

