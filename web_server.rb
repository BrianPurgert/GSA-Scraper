require 'rubygems'
require 'sinatra'
require 'sequel'
require 'adv/adv_scrape'


# JUNK ============================================================
require 'mysql2'
require 'logger'

DB = Sequel.

DB.create_table :links do
	primary_key :id
	varchar :title
	varchar :link
end

class Link < Sequel::Model;
end

get '/' do
	@links = Link.all
	haml :links
end

post '/' do
	"<div style='width:100%; background-color:blue;'>Posted n roasted<div>"
end
# TRUNK ===========================================================


get '/frank-says' do
	'Put this in your pipe & smoke it!'

end


get '/r' do
	# matches "GET /hello/foo" and "GET /hello/bar"
	# params['name'] is 'foo' or 'bar'
	
	
end
