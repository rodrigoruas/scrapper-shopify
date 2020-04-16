def export_to_csv(array,csv_file,headers)
    CSV.open(csv_file, "w",
            :write_headers=> true,
            :col_sep => ";",
            :headers => headers) do |csv|
      array.each do |hash|
        csv << hash.values
      end
    end
  end

  def export_array_to_json(array,json_file)
    File.open(json_file,"w") do |f|
      f.puts JSON.pretty_generate(array)
    end
  end

  def read_json(file_path)
    JSON.parse((open(file_path).read).to_json)
  end

  def read_csv(csv_file)
    CSV.open(csv_file, headers: :first_row, col_sep: ";").map(&:to_h)
  end

  def get_urls_from_csv(csv_file)
    array = []
    CSV.open(csv_file, headers: :first_row, col_sep: ";").each do |line|
      data = line.to_h
      array << data["website"]
    end
    array
  end

  def read_csv(csv_file)
    # CSV.open(csv_file, headers: :first_row, col_sep: ";").map(&:to_h)
    CSV.open(csv_file, headers: :first_row, col_sep: ";").map do |line|
      data = line.to_h
      array << data["website"]
    end
  end

def create_html_file(url)
  open("french_websites/#{url.split("/").last}.html", 'wb') do |file|
    file << open(url).read
  end
end

