require './state_data'

class CsvReader
  def read
    csv_files = Dir["data/*.csv"]

    csv_files.each do |csv_file|
        path = File.expand_path("../#{csv_file}", __FILE__)
        
        CSV.foreach(path) do |row|
            state = csv_file.split('.')[1].split('/')[1]
            year = row[0].to_i
            month = row[1].to_i
            min_temp_rcp45 = row[2].to_f
            max_temp_rcp45 = row[3].to_f
            precipitation_rcp45 = row[4].to_f
            min_temp_rcp85 = row[5].to_f
            max_temp_rcp85 = row[6].to_f
            precipitation_rcp85 = row[7].to_f
            
            data = StateData.new(state, year, month,
                                  min_temp_rcp45, max_temp_rcp45,
                                  precipitation_rcp45,
                                  min_temp_rcp85, max_temp_rcp85,
                                  precipitation_rcp85)
                                    
            Cache.add(data)
        end
    end
  end
end
