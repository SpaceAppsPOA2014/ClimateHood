require 'sinatra'
require 'csv'
require './state_data'
require './csv_reader'
require './cache'
require 'json'

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
end


configure do
  self.load_dataset() if !Cache.is_loaded()
end

