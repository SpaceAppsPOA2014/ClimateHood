require 'csv'
require './state_data'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'app.sqlite3.db'
)


task :create_db do
  sh "sqlite3 app.sqlite3.db < database/create.sql" 
end

task :import do
    csv_files = Dir["data/*.csv"]
    
    csv_files.each do |csv_file|
      path = File.expand_path("../#{csv_file}", __FILE__)

      CSV.foreach(path) do |row|
        state = csv_file.split('.')[0]  
        year = row[0]
        month = row[1]
        min_temp_rcp45 = row[2]
        max_temp_rcp45 = row[3]
        precipitation_rcp45 = row[4]
        min_temp_rcp85 = row[5]
        max_temp_rcp85 = row[6]
        precipitation_rcp85 = row[7]

        data = StateData.create(state: state, year: year, month: month,
                             min_temp_rcp45: min_temp_rcp45, max_temp_rcp45: max_temp_rcp45, 
                             precipitation_rcp45: precipitation_rcp45,
                             min_temp_rcp85: min_temp_rcp85, max_temp_rcp85: max_temp_rcp85, 
                             precipitation_rcp85: precipitation_rcp85)
        
        puts data
        data.save
      end
    end
end
