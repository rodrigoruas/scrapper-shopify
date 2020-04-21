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
start_index = 1000
end_index = 1500


headers = %w(url emails)
emails = parse_with_pool(start_index, end_index)

export_array_to_json(emails,"emails/emails-#{start_index}-#{end_index}.json")
export_to_csv(emails,"emails/emails-#{start_index}-#{end_index}.csv",headers)

puts "Goodbye!"

