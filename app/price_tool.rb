require 'sinatra'
require 'forme'
require 'forme/sinatra'
require 'forme/bs3'
Forme.default_config = :bs3

get '/' do
	'Hello world!'
	f = Forme::Form.new
	f.open(:action=>'/foo', :method=>:post) # '<form action="/foo" method="post">'
	f.input(:textarea, :value=>'foo', :name=>'bar') # '<textarea name="bar">foo</textarea>'
	f.input(:text, :value=>'foo', :name=>'bar') # '<input name="bar" type="text" value="foo"/>'
	f.close # '</form>'
end

post '/' do
	# .. create something ..
end
