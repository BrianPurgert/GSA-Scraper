require 'rubygems'
require 'sinatra'
require 'sequel'
require File.expand_path(File.dirname(__FILE__) + '/config/adv_scrape')

# t
# JUNK ============================================================
require 'mysql2'
require 'logger'

DB = Sequel.connect(
	adapter:  "mysql2",
	host:     ENV['MYSQL_HOST'],
	database: 'gsa',
	user:     ENV['MYSQL_USER'],
	password: ENV['MYSQL_PASS']
)
@DB.loggers << Logger.new($stdout)
@DB.extension :pretty_table

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
