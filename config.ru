# Example config.ru

require 'sinatra'
require 'grape'
require_relative 'GSA/adv/gsa_advantage'



class API < Grape::API
  get :hello do
    { hello: 'world' }
  end
end

class Web < Sinatra::Base
  get '/' do
    ''
  end
end

use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]