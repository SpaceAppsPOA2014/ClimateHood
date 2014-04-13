require 'sinatra'
require 'csv'
require 'json'
require './state_data'
require './csv_reader'
require './cache'
require 'slim'
require 'sass'
require 'compass'

module ClimateHood
  class CssHandler < Sinatra::Base
    get '/css/normalize.css' do
      content_type 'text/css', :charset => 'utf-8'
      scss :'stylesheets/normalize'
    end

    get '/css/nv.d3.min.css' do
      content_type 'text/css', :charset => 'utf-8'
      scss :'stylesheets/nv.d3.min'
    end

    get '/main.css' do
      content_type 'text/css', :charset => 'utf-8'
      scss :'stylesheets/main'
    end
  end

  class App < Sinatra::Base
    use CssHandler

    get '/' do
      slim :index
    end

    def self.load_dataset
      puts "running"
      reader = CsvReader.new
      reader.read
    end

    get '/api' do
      content_type :json

      year = params[:year]
      month = params[:month]
      state = params[:state]
      duration = params[:duration]

      if !year || !month || !state || !duration
        return status 400
      end

      result = filter_by(state, year.to_i, month.to_i, duration.to_i)

      result.to_json
    end

    def us_states
      states = []
      csv_files = Dir["data/*.csv"]

      csv_files.each do |f|
        path = File.expand_path("../#{f}", __FILE__)

        state = f.split('.')[0].split('/')[1]

        states << state
      end

      states
    end

    def filter_by(state, year, month, duration)
      result = Cache.data.select do |d|
        d.year >= year &&
          d.year <= (year + duration) &&  
          d.month >= month &&
          d.state == state
      end

      result.each{|s|
        puts s.year
        puts s.month
        puts s.min_temp_rcp45
        puts s.max_temp_rcp45
        puts s.precipitation_rcp45
        puts s.min_temp_rcp85
        puts s.max_temp_rcp85
        puts s.precipitation_rcp85
        puts ""
      }
      result
    end

    get '/api/summary' do
      year = params[:year]
      month = params[:month]
      state = params[:state]
      duration = params[:duration]

      if !year || !month || !state || !duration
        halt 400, "Year(#{year}), month(#{month}), state(#{state}) and duration(#{duration}) are all required."
      end

      results = filter_by(state, year.to_i, month.to_i, duration.to_i)
      
      { 
        min_temp_rcp45: results.min_by{|x| x.min_temp_rcp45.to_f}.min_temp_rcp45,
        max_temp_rcp45: results.max_by{|x| x.max_temp_rcp45.to_f}.max_temp_rcp45,
        min_precipitation_rcp45: results.min_by{|x| x.precipitation_rcp45.to_f}.precipitation_rcp45,
        max_precipitation_rcp45: results.max_by{|x| x.precipitation_rcp45.to_f}.precipitation_rcp45,
        min_temp_rcp85: results.min_by{|x| x.min_temp_rcp85.to_f}.min_temp_rcp85,
        max_temp_rcp85: results.max_by{|x| x.max_temp_rcp85.to_f}.min_temp_rcp85,
        min_precipitation_rcp85: results.min_by{|x| x.precipitation_rcp85.to_f}.precipitation_rcp85,
        max_precipitation_rcp85: results.max_by{|x| x.precipitation_rcp85.to_f}.precipitation_rcp85
      }.to_json
    end

    configure do
      self.load_dataset() if !Cache.is_loaded()

      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = :"stylesheets/"
      end

      set :scss, Compass.sass_engine_options
      set :public_dir,  File.dirname(__FILE__)    + '/views'
    end
  end
end
