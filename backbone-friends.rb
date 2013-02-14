require 'sinatra'

get '/' do
  haml :index
end

get '/application.js' do
  coffee :application
end

get '/friends_app.js' do
  coffee :friends_app
end

get '/models.js' do
  coffee :models
end

get '/views.js' do
  coffee :views
end

get '/routers.js' do
  coffee :routers
end
