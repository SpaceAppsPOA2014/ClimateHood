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

  class App < Sinatra::Base

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

    def filter_by(state, year, month, duration)
      result = Cache.data.select do |d|
        d.year >= year &&
          d.year <= (year + duration) &&  
          d.month >= month &&
          d.state == state
      end

      puts "the number of results is", result

      result
    end

    get '/api/summary' do
      year = params[:year]
      month = params[:month]
      state = params[:state]
      duration = params[:duration]

      if !year || !month || !state || !duration
        return status 400
      end

      results = filter_by(state, year.to_i, month.to_i, duration.to_i)

      puts "hello", results.count
      
      { 
        min_temp_rcp45: results.min_by(&:min_temp_rcp45).min_temp_rcp45,
        max_temp_rcp45: results.max_by(&:max_temp_rcp45).max_temp_rcp45,
        min_precipitation_rcp45: results.min_by(&:precipitation_rcp45).precipitation_rcp45,
        max_precipitation_rcp45: results.max_by(&:precipitation_rcp45).precipitation_rcp45,
        min_temp_rcp85: results.min_by(&:min_temp_rcp85).min_temp_rcp85,
        max_temp_rcp85: results.max_by(&:max_temp_rcp85).min_temp_rcp85,
        min_precipitation_rcp85: results.min_by(&:precipitation_rcp85).precipitation_rcp85,
        max_precipitation_rcp85: results.max_by(&:precipitation_rcp85).precipitation_rcp85
      }.to_json
    end

    configure do
      self.load_dataset() if !Cache.is_loaded()

      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = 'views/stylesheets'
      end

      set :scss, Compass.sass_engine_options
      set :public,  File.dirname(__FILE__)    + '/views'
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
end
