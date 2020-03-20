require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative 'indexator'

configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# ROUTES ...

options '*' do
  response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end

post '/v1/indexations' do
  params = JSON(request.body.read.to_s)
  contract_signature_date = params['signed_on']
  contract_start_date = params['start_date']
  base_rent = params['base_rent']
  x = Indexator.new(contract_signature_date, contract_start_date, base_rent)
  return { new_rent: x.new_rent }.to_json
end
