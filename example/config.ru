# Sample app for DrChrono OAuth2 Strategy
# Make sure to setup the ENV variables DRCHRONO_CLIENT_ID and DRCHRONO_CLIENT_SECRET
# Run with "bundle exec rackup"

require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-drchrono'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/drchrono'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env['omniauth.auth'])
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie, :secret => 'change_me'

use OmniAuth::Builder do
  provider :drchrono, ENV['DRCHRONO_CLIENT_ID'], ENV['DRCHRONO_CLIENT_SECRET'], scope: 'user:read'
end

run App.new
