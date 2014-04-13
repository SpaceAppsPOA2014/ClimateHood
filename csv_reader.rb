require './state_data'

class CsvReader
  def read
    csv_files = Dir["data/*.csv"]

    csv_files.each do |csv_file|
        path = File.expand_path("../#{csv_file}", __FILE__)
        
        CSV.foreach(path) do |row|
            state = csv_file.split('.')[0].split('/')[1]
            year = row[0]
            month = row[1]
            min_temp_rcp45 = row[2]
            max_temp_rcp45 = row[3]
            precipitation_rcp45 = row[4]
            min_temp_rcp85 = row[5]
            max_temp_rcp85 = row[6]
            precipitation_rcp85 = row[7]
            
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
