require 'sinatra'
require_relative 'database/spreadsheet/report'
require_relative 'adv/gsa_advantage'

# JUNK ============================================================
# list_files(files)
# import_spreadsheets(files, tables)
# export_price_comparisons(files, tables)
# TRUNK ===========================================================


get '/frank-says' do
	'Put this in your pipe & smoke it!'
	
end

get '/' do
	"<div>Hello World <a style='
	color: #24292e;
	background-color: #eff3f6;
	background-image: -webkit-linear-gradient(270deg, #fafbfc 0%, #eff3f6 90%);
	background-image: linear-gradient(-180deg, #fafbfc 0%, #eff3f6 90%);' href='/r/sam'>sup</a>
</div>"

end

post '/' do
	"<div style='width:100%; background-color:blue;'>Posted n roasted<div>"
end

get '/r' do
	# matches "GET /hello/foo" and "GET /hello/bar"
	# params['name'] is 'foo' or 'bar'
	
	
end
