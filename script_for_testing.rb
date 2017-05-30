# require 'mysql2'
# require 'nokogiri'
# require 'rubygems'
# require 'thread'

# require_relative 'gsa_advantage'
# require_relative 'gsa_advantage_selectors'
# require_relative 'pages/gsa_advantage_page'

	 # p Select::FSSI
# caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"binary" => [ "C:\\Users\\Brian\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe" ]})

 # Selenium::WebDriver::Chrome.binary = chromedriver_path
# C:\Program Files (x86)\Google\Chrome\Application\chrome.exe

# disable-infobars argument from ChromeOptions

require 'watir'
Selenium::WebDriver::Chrome.path = 'C:\Users\Brian\AppData\Local\Google\Chrome SxS\Application\chrome.exe'


 browser = Watir::Browser.new :chrome
browser.goto 'chrome://version/'
# puts browser.text
browser.goto 'https://brianpurgert.com/'
#main > article > div > ul:nth-child(2) > li




 	browser.divs(css: '*').each do |element|
 		p "#{element.inspect}:\t#{element.text}"
	      # element.flash(color: "green",  outline: TRUE )
	      element.flash color:'red'
	      browser.execute_script "arguments[0].style.borderRadius = '25px';
							arguments[0].style.margin = '10px 10px 10px 10px';
							arguments[0].style.padding = '10px 10px 10px 10px';
							arguments[0].style.outline = '5px dotted green';
							arguments[0].appendChild(document.createTextNode(arguments[0]));", element,element.inspect
 	end

sleep 100

#,switches:%w(headless disable-gpu)


sleep 10
exit

# chrome_canary = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: {binary: 'C:\\Users\\Brian\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe'})

# driver = Selenium::WebDriver.for desired_capabilities: caps

 # Watir::Selenium::Driver.new( :browser => :chrome,  :desired_capabilities => caps)




# --headless --disable-gpu --remote-debugging-port=9222
#           Canary Location
# ,binary: [canary]



# mycanary = "C:\\Users\\Brian\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe"
# browser = Watir::Browser.start('https://www.reddit.com/',:chrome , switches:%w(headless disable-gpu))
#
# 	browser.divs(css: '.entry').each do |element|
# 		puts "#{element.text}\n"
# 	end



# prefs = {
# download: {
# prompt_for_download: false,
# default_directory: '/path/to/dir'
# }
# }
# b = Watir::Browser.new :chrome, prefs: prefs
#
# ChromeOptions options = new ChromeOptions();
# options.addArguments("user-data-dir=/path/to/your/custom/profile");

# ChromeOptions options = new ChromeOptions();
# options.setBinary("/path/to/other/chrome/binary");

# options.setBinary("C:\\Users\\u0125202\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe")





#wikiArticle > dl:nth-child(n) > dt:nth-child(1) > a








#
# def split(b,n,total)
# 	p avail_height = b.execute_script("return screen.availHeight")
# 	p avail_width = b.execute_script("return screen.availWidth")
# 	x_part_size = avail_width/total
# 	b.window.move_to(x_part_size*n, 0)
# 	b.window.resize_to(x_part_size, avail_height)
# end
# 	browsers = []
# 	browsers[0] = Watir::Browser.new :chrome
# 	browsers[1] = Watir::Browser.new :chrome
# 	browsers[2] = Watir::Browser.new :chrome
# browsers[3] = Watir::Browser.new :chrome
#
# 	browsers[0].goto 'https://govconsvcs.com/'
# 	browsers[1].goto 'https://govconsvcs.com/'
# 	browsers[2].goto 'https://reddit.com/'
# 	browsers[3].goto 'https://voat.com/'
#
# sleep 10
# exit
#



#
# all_sql_data = client.query('
# SELECT *
# FROM `mft_data`.`lowest_price_contractor`;
# ')
# #
# result.each_with_index  do |row, index|
# 		puts "#{index}\t#{row}"
# end
#
# client.query('
# INSERT INTO
# FROM `mft_data`.`lowest_price_contractor`
# WHERE lowest_contractor IS NULL ;
# ')
#
# result = client.query('
# SELECT *
# FROM `mft_data`.`lowest_price_contractor`
# WHERE lowest_contractor IS NULL ;
# ')
#
# result = client.query('
# INSERT INTO manufacturer_name
# VALUES ()
# FROM `mft_data`.`lowest_price_contractor`
# WHERE lowest_contractor IS NULL ;
# ')
#
#
# result.each_with_index  do |row, index|
#   puts "#{index}\t#{row}"
# end
#




# basedir = './../Input-Files/'
# files = Dir.glob(basedir+"*.xls")
# files.each_with_index do |file, num|
#   puts "#{num}   #{file}"
# end
# pick_num = gets.to_i
# puts files[pick_num]

#
# proxy_list = %w(
#   104.151.234.175:8080
#   104.151.234.176:8080
#   104.151.234.177:8080
#   104.151.234.178:8080
#   104.151.234.179:8080
#   104.151.234.180:8080
#   104.151.234.170:8080
#   23.106.254.173:29842
#   23.106.254.89:29842
#   172.241.136.212:29842
#   23.106.254.219:29842
#   172.241.136.164:29842
#   23.106.254.252:29842
#   104.151.234.171:8080
#   104.151.234.172:8080
#   104.151.234.173:8080
#   104.151.234.174:8080
#   104.151.234.181:8080
#   104.151.234.182:8080
#   104.151.234.183:8080
#   104.151.234.184:8080
#   104.151.234.185:8080
#   104.151.234.186:8080
#   104.151.234.187:8080
#   104.151.234.188:8080
#   104.151.234.189:8080
# )

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
