def get_urls_from_csv(csv_file)
  array = []
  CSV.open(csv_file, headers: :first_row, col_sep: ";").each do |line|
    data = line.to_h
    array << data["website"]
  end
  array
end

def export_to_csv(links, file_name)
  CSV.open(file_name, "w") do |csv|
    csv << ["#", "website"]
    links.each_with_index do |link, index|
      csv << [index, link]
    end
  end
end

def create_html_file(url)
  open("french_websites/#{url.split("/").last}.html", 'wb') do |file|
    file << open(url).read
  end
end

def parse_with_pool(start, finish)
  pool = Thread.pool(500)
  start_time = Time.now
  @links[start..finish].each_with_index do |link, index|
    pool.process {
      url = "http://#{link}"
      begin
        response = HTTParty.get(url)
        if((response.body.include?('lang="fr"')) || (response.body.include?('"contentLanguage"="fr"')))
          print 'Allez les bleus!'
          file = create_html_file(url)
        end
        p "Success!"
      rescue => e
        p e
      end
    }  
  end
  pool.shutdown
  p "#{(Time.now- start_time).round(2)} seconds"
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