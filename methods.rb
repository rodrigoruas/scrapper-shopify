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


def create_html_file(url)
  open("french_websites/#{url.split("/").last}.html", 'wb') do |file|
    file << open(url).read
  end
end

def find_emails(content, domain, array, url)
  emails = content.scan(/\b[A-Z0-9._%+-]+@#{domain}[A-Z]{2,4}\b/i).uniq
  array << {url: url, emails: emails}
  return !emails.empty?
end

def parse_with_pool(start, finish)
  emails_array = []
  pool = Thread.pool(500)
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
          # file = create_html_file(url)
          founded = find_emails(response.body, domain, emails_array, url)
          unless founded
            doc = Nokogiri::HTML(response.body)
            #Get all links in footer
            doc.css('footer a').each do |fl|
              # Reject external links
              unless fl['href'].include?('http')
                response = HTTParty.get(url + fl['href'], timeout: 5)
                find_emails(response.body, domain, emails_array, url)
              end
            end
          end
        end
        p "Success!"
      rescue => e
        p e
      end
    }  
  end
  pool.shutdown
  emails = emails_array.uniq
  p "#{(Time.now- start_time).round(2)} seconds"
  p "Number of french websites: #{french}"
  emails
end

def parse_without_pool(start, finish)
  start_time = Time.now
  @links[start..finish].each_with_index do |link, index|
    p "======================================================"
    p "parsing: #{index}"
    url = "http://#{link}"
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
  end
  p "#{(Time.now- start_time).round(2)} seconds"
end