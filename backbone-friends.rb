require 'sinatra'

get '/' do
  haml :index
end

get '/application.js' do
  coffee :application
end

get '/models.js' do
  coffee :models
end
