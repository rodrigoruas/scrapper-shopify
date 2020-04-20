require 'thread/pool'
require 'httparty'
require 'csv'
require "open-uri"
require_relative 'methods'
require 'nokogiri'
require 'byebug'
require 'json'

data_file = "part1.csv"

puts "Open CSV file"
@links = get_urls_from_csv(data_file)

# Write here the interval you want to parse:

emails = parse_with_pool(0,300)

export_array_to_json(emails,"emails.json")
puts "Goodbye!"

