require 'sinatra'
require 'csv'
require 'json'
require './state_data'
require './csv_reader'
require './cache'
require 'slim'
require 'sass'
require 'compass'

get '/' do
  slim :index
end

module ClimateHood
  class App < Sinatra::Base
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

      result
    end

    configure do
      self.load_dataset() if !Cache.is_loaded()

      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = 'views/stylesheets'
      end

      set :scss, Compass.sass_engine_options
    end
  end
end

get '/main.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :'stylesheets/main'
end
