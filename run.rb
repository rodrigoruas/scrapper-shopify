require 'thread/pool'
require 'httparty'
require 'csv'
require 'net/http'
require 'openssl'
require "open-uri"
require_relative "methods"

data_file = "part1.csv"

puts "Open CSV file"
@links = get_urls_from_csv(data_file)

puts "Reading links..."
@links.first(100).each_with_index do |link, index|
  url = "http://#{link}"
  p index
  begin
    response = HTTParty.get(url)
    if((response.body.include?('lang="fr"')) || (response.body.include?('"contentLanguage"="fr"')))
      print 'Allez les bleus!'
      create_html_file(url)
    end
    p "Success!"
  rescue => e
    p "Erro:"
    p e
  end
end

puts "Exporting french links to CSV..."

export_to_csv(@french_links, export_file_name)
