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
    CSV.open(csv_file, headers: :first_row).map(&:to_h)
  end
  
  # def create_html_file(url)
  #   open("festivals_htmls1/#{page_number}.html", 'wb') do |file|
  #     file << open(url).read
  #   end
  # end
  
#   def create_slugs(string)
#     string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub("--","-")
#   end
  