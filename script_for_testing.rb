require 'page-object'
require 'watir'
require 'page-object/page_factory'
require_relative 'pages/gsa_advantage_page'
require 'mysql2'
require_relative 'gsa_advantage'
require 'thread'

require 'rubygems'
require 'nokogiri'
# require 'httparty'
require_relative 'gsa_advantage_selectors'

	 p Select::FSSI
	Select.css

exit

dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'httparty')
require 'pp'

class HtmlParserIncluded < HTTParty::Parser
	def html
		Nokogiri::HTML(body)
	end
end

class Page
	include HTTParty
	parser HtmlParserIncluded
end

pp Page.get('http://www.google.com')

exit

browser1 = initialize_browser(0,1)
# --headless --disable-gpu --remote-debugging-port=9222
      browser = Watir::Browser.start 'https://developer.mozilla.org/en-US/docs/Web/API/Element'
	# browser.div(id: "wiki-content").javascript("scrollIntoView()")
	browser.divs.each do |element|
		element.flash(color: "green")
	end




#wikiArticle > dl:nth-child(n) > dt:nth-child(1) > a

sleep 10
exit








# mfr_list_pages = ("A".."Z").to_a << "0"
# producer = Thread.new do
# 	mfr_list_pages.each do |l|
# 		1..50.each do |i|
# 		queue << i
# 		puts "#{l} produced"
# 			end
# 	end
# end
#
# consumer = Thread.new do
# 	5.times do |i|
# 		value = queue.pop
# 		sleep rand(i/2) # simulate expense
# 		puts "consumed #{value}"
# 	end
# end

# mfr_list_pages = ("A".."Z").to_a << "0"
# puts mfr_list_pages
# sleep 10
# testst = "https://www.gsaadvantage.gov/advantage/s/refineSearch.do;jsessionid=F47E648BFB6508CEBD083ABD30A4CFCB.F4?q=1:4*&_a=u&_q=28:5SCOTSMAN"
# rx_mfr = /(?<=\q=28:5).*/
# puts rx_mfr.match()

# whitespace =""

# client = Mysql2::Client.new(
# 		host:     "70.61.131.180",
# 		username: "mft_data",
# 		password: "GoV321CoN",
# 		flags:    Mysql2::Client::MULTI_STATEMENTS)

def split(b,n,total)
	p avail_height = b.execute_script("return screen.availHeight")
	p avail_width = b.execute_script("return screen.availWidth")
	x_part_size = avail_width/total
	b.window.move_to(x_part_size*n, 0)
	b.window.resize_to(x_part_size, avail_height)
end
	browsers = []
	browsers[0] = Watir::Browser.new :chrome
	browsers[1] = Watir::Browser.new :chrome
	browsers[2] = Watir::Browser.new :chrome
browsers[3] = Watir::Browser.new :chrome

	browsers[0].goto 'https://govconsvcs.com/'
	browsers[1].goto 'https://govconsvcs.com/'
browsers[2].goto 'https://reddit.com/'
browsers[3].goto 'https://voat.com/'

sleep 10
exit




# mft_data.lowest_price_contractor.mpn
# mft_data.lowest_price_contractor.manufacturer_name
# mft_data.lowest_price_contractor.lowest_contractor
# mft_data.lowest_price_contractor.lowest_contractor_price
# mft_data.lowest_price_contractor.lowest_contractor_page_url
# mft_data.lowest_price_contractor.mpn_page_url

all_sql_data = client.query('
SELECT *
FROM `mft_data`.`lowest_price_contractor`;
')
#
result.each_with_index  do |row, index|
		puts "#{index}\t#{row}"
end

client.query('
INSERT INTO
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')

result = client.query('
SELECT *
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')

result = client.query('
INSERT INTO manufacturer_name
VALUES ()
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')


result.each_with_index  do |row, index|
  puts "#{index}\t#{row}"
end





# basedir = './../Input-Files/'
# files = Dir.glob(basedir+"*.xls")
# files.each_with_index do |file, num|
#   puts "#{num}   #{file}"
# end
# pick_num = gets.to_i
# puts files[pick_num]
sleep 100

proxy_list = %w(
  104.151.234.175:8080
  104.151.234.176:8080
  104.151.234.177:8080
  104.151.234.178:8080
  104.151.234.179:8080
  104.151.234.180:8080
  104.151.234.170:8080
  23.106.254.173:29842
  23.106.254.89:29842
  172.241.136.212:29842
  23.106.254.219:29842
  172.241.136.164:29842
  23.106.254.252:29842
  104.151.234.171:8080
  104.151.234.172:8080
  104.151.234.173:8080
  104.151.234.174:8080
  104.151.234.181:8080
  104.151.234.182:8080
  104.151.234.183:8080
  104.151.234.184:8080
  104.151.234.185:8080
  104.151.234.186:8080
  104.151.234.187:8080
  104.151.234.188:8080
  104.151.234.189:8080
)

# browser = []
# gsa_advantage = []
#
# proxy_list.each_with_index do |proxy, index|
# 	puts proxy
# 	puts index
#   browser[index] = Watir::Browser.new :chrome, switches: ["--proxy-server=#{proxy}"]
#   gsa_advantage[index] = GsaAdvantagePage.new(browser[index])
#   gsa_advantage[index].browser.goto 'http://www.ipaddresslocation.org/'
# end
