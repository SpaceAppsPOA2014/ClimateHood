# requires
require 'sinatra'
require 'csv'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'app.sqlite3.db'
)

get '/state/:name' do
end
