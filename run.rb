require_relative "methods"
require "json"
require "csv"
require "byebug"

array = []
file = File.open('part2.json').read
file.each_line do |line|
    z = line.gsub(" :", "\"").gsub("=>", "\": ").gsub("{:", "{\"").gsub("\n","").gsub(", Inc","").gsub("\\n","")
    z.gsub!("nil", "0") if z.include? "nil"
    begin
        array << JSON.parse(z) 
    rescue => e
        p line
        p e
    end
end

headers = %w(number website website_ip_address web_hosting_company web_hosting_location 
web_hosting_city world_site_popular_rating website_popularity ip_reverse_dns 
top_level_hostname web_hosting_state dns_records record_update_time)

export_to_csv(array,"part2.csv",headers)
