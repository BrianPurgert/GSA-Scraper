require 'sinatra'
get '/frank-says' do
	'Put this in your pipe & smoke it!'
end


get '/' do
	"<div>Hello World <a style='
	color: #24292e;
	background-color: #eff3f6;
	background-image: -webkit-linear-gradient(270deg, #fafbfc 0%, #eff3f6 90%);
	background-image: linear-gradient(-180deg, #fafbfc 0%, #eff3f6 90%);' href='/hello/sam'>sup</a>
</div>"

end

post '/' do
	"<div style='width:100%; background-color:blue;'>Posted n roasted<div>"
end

get '/r/:name' do
	# matches "GET /hello/foo" and "GET /hello/bar"
	# params['name'] is 'foo' or 'bar'
	"Hello #{params['name']}!"
	
		send_file 'foo.png', :type => :jpg
	
end
