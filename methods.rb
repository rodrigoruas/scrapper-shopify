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
