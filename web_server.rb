require 'rubygems'
require 'sinatra'
require 'sequel'
require File.expand_path(File.dirname(__FILE__) + '/adv/gsa_advantage')
require File.expand_path(File.dirname(__FILE__) + '/config/adv_scrape')


# JUNK ============================================================
require 'mysql2'
require 'logger'
puts ""
# DB = Sequel.connect(
# 	adapter:  "mysql2",
# 	host:     ENV['MYSQL_HOST'],
# 	database: 'gsa',
# 	user:     ENV['MYSQL_USER'],
# 	password: ENV['MYSQL_PASS']
# )


DB.extension :pretty_table

DB.create_table? :links do
	primary_key :id
	varchar :title
	varchar :link
end

# class IPROD < Sequel::Model; end

get '/' do
	@iprod = DB[:iprod].limit(100).all
		erb :iprod
end


# TRUNK ===========================================================

# name LIKE '%CERTOL%'




get '/r' do
	# matches "GET /hello/foo" and "GET /hello/bar"
	# params['name'] is 'foo' or 'bar'


end
