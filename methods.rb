def get_urls_from_csv(csv_file)
  array = []
  CSV.open(csv_file, headers: :first_row, col_sep: ";").each do |line|
    data = line.to_h
    array << data["website"]
  end
  array
end

def export_array_to_json(array,json_file)
  File.open(json_file,"w") do |f|
    f.puts JSON.pretty_generate(array)
  end
end

def export_to_csv(array,csv_file,headers)
  CSV.open(csv_file, "w",
          :write_headers=> true,
          :headers => headers) do |csv|
    array.each do |hash|
      csv << [hash.values.first, hash.values.last.join(",")]
    end
  end
end

def find_emails(content, domain, array)
  content.scan(/\b[A-Z0-9._%+-]+@#{domain}[A-Z]{2,4}\b/i).uniq
end

def parse_with_pool(start, finish)
  emails_array = []
  pool = Thread.pool(200)
  start_time = Time.now
  french = 0
  @links[start..finish].each_with_index do |link, index|
    pool.process {
      url = "http://#{link}"
      domain = link.gsub(link.split('.')[-1], "")
      begin
        response = HTTParty.get(url)
        if((response.body.include?('lang="fr"')) || (response.body.include?('"contentLanguage"="fr"')))
          french = french + 1
          print 'Allez les bleus!'
          founded = find_emails(response.body, domain, emails_array)
          unless founded == []
            emails_array << {
              url: url,
              emails: founded
            }
          else
            doc = Nokogiri::HTML(response.body)
            emails = []
            doc.css('footer a').each do |fl|
              unless fl['href'].include?('http')
                response = HTTParty.get(url + fl['href'], timeout: 5)
                found = find_emails(response.body, domain, emails_array)
                emails << found unless found == []
              end
            end
            emails_array << {
              url: url,
              emails: emails.uniq.flatten
            }
          end
        end
        p "Success!"
      rescue => e
        p e
      end
    }
  end
  pool.shutdown
  emails = emails_array.reject!{|item| item[:emails] == []}
  p "#{(Time.now- start_time).round(2)} seconds"
  p "Number of french websites: #{french}"
  unless emails.nil?
    p "Number of pages with email: #{emails.length}"
    emails
  else
    p  "No email found"
    []
  end
end
