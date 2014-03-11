require 'bundler/setup'

require 'sinatra'
require 'slim'

configure :development do
  require 'sinatra/reloader'
  require 'pry'
end

get '/' do
  slim :index
end

post '/files' do
end

get '/files/:id' do
end

get '/files/:id/content' do
end

delete '/files/:id' do
end

__END__
