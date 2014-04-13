require 'sinatra'
require 'csv'
require 'json'
require './state_data'
require './csv_reader'
require './cache'

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
  {"params" => params}.to_json

  year = params[:year]
  month = params[:month]
  state = params[:state]
  duration = params[:duration]

  result = Cache.data.select do |d|
    d.year >= year &&
    d.year.to_i <= (year.to_i + duration.to_i) &&  
    d.month.to_i >= month.to_i &&
    d.state == state
  end

  result.to_json
end

configure do
  self.load_dataset() if !Cache.is_loaded()
end

