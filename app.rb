require 'sinatra'
require 'csv'
require 'json'
require './state_data'
require './csv_reader'
require './cache'

module ClimateHood
  class App < Sinatra::Base
    def self.load_dataset
      puts "running"
      reader = CsvReader.new
      reader.read
    end

    get '/' do
      File.read(File.join('public', 'index.html'))
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
    end
  end
end
