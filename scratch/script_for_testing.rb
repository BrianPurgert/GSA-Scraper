
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil


# require 'socket'
require_relative '../adv/gsa_advantage'
require 'logger'

logger = Logger.new $stdout
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
# P_list = ['192.225.106.163', '192.225.98.17','69.162.164.78']

def sample1
	proxy       = P_list.sample
	url         = 'https://www.gsaadvantage.gov/advantage/search/headerSearch.do'
	switch      = ["headless", "disable-gpu","proxy-server=#{proxy}:45623"]
	# browser     = Watir::Browser.start url, :chrome, switches: switch
	# raise 'Welcome to GSA Advantage! not in title' unless browser.title.include? 'Welcome to GSA Advantage!'
	# cookie      = browser.cookies.to_a
	# user_agent  = browser.driver.execute_script("return navigator.userAgent;")

	agent   =  Mechanize.new do |a|
		a.set_proxy proxy, 45623
		a.user_agent = user_agent
		a.cookie_jar = cookie
		# a.follow_meta_refresh = true
	end
	return agent
end



def sample2
	browser = Watir::Browser.start 'chrome://version/',:chrome
	browser.goto 'https://www.gsaadvantage.gov/'
	 browser.cookies.to_a.inspect
	browser.cookies.save                            # '.cookies' is default
	browser.close
	browser = Watir::Browser.start 'https://www.gsaadvantage.gov/',:chrome
	puts "\n----\n#{browser.cookies.to_a.inspect}\n----\n"
	browser.cookies.clear
	browser.cookies.load
	puts browser.cookies.to_a.inspect
end


def sample3
threads     = []
@agent      = []
(1..2).each do |pg|
	threads << Thread.new do
		proxy       = P_list.sample
		@agent[pg]  = initialize_browser
		cookies     = @agent[pg].browser.cookies.to_a

		@agent[pg]  =  Mechanize.new do |a|
			a.set_proxy proxy, 45623
		end
		# driver.executeScript(return navigator.userAgent;
		#save(file = '.cookies')

	end
end
threads.each { |thr| thr.join }
end

def sample4
(1..5).each do |pg|
	threads << Thread.new do
		@agent[pg] =  Mechanize.new do |a|
			a.set_proxy P_list.sample, 45623
			a.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.82 Safari/537.36"
			a.follow_meta_refresh = true
		end
		@agent[pg].cookie_jar.to_a.inspect
		@agent[pg].get("https://www.gsaadvantage.gov/advantage/main/start_page.do")
		@agent[pg].cookie_jar
		html = @agent[pg].get_file("https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=14:760000&c=100&s=9&p=#{pg}")
		# @agent[pg].log = logger
		# cookie_jar= cookie_jar

		
		
		uri = URI "search.do-#{pg}.html"
		file = Mechanize::File.new uri, nil, html
		  filename = file.save!  # saves to test.html
		p filename
		p @agent[pg].cookie_jar.to_a.inspect
	end
end
threads.each { |thr| thr.join }
end

def sample5
agent[] = Mechanize.new
agent.set_proxy '69.162.164.78', 45623
page = agent.get('https://www.gsaadvantage.gov/advantage/main/start_page.do')
puts page.body
[1..5].to_a.each do |page_number|
	p page_number
end
page = agent.get('https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=14:7900000000&c=100&s=9&p=1')
page.links.each do |link|
	puts link.text
end
end



def open(url ,name='new_tab' , specs='specs' , replace='replace')
	# window = Watir::Window.new browser.driver,
	# p browser.window.inspect, browser.window.title, browser.window.url
	expected = @browser.windows.size + 1
	@browser.driver.execute_script("window.open(arguments[0]);",url)
# "	function OpenInNewTabWinBrowser(url) {
# 		var win = window.open(url, '_blank');
# 		win.focus();
# 	}"
	Watir::Wait.until { @browser.windows.size == expected }
	p "Opens: #{@browser.windows.size}"
	# browser.driver.switch_to.window(browser.driver.window_handles.last)
	# p browser.window.inspect, browser.window.title, browser.window.url
end

def open_message(message)
	@browser.driver.execute_script("window.open('', 'MsgWindow', 'width=400,height=300').document.write('<p>#{message}</p>');",message)
end

def use_tab(i)
	@browser.driver.switch_to.window(@browser.driver.window_handles[i])
	p @browser.url
end

def close_window
	window.open("closeable.html")
	window.close()
end



def sample6
@threads     = []
@browser = Watir::Browser.start 'http://www.deelay.me/0',:chrome
@browser.alert
	open_message "errrroooo"



5.times do
	open("http://www.deelay.me")
end

open_message "reeerrrrrrrrrrrrrreee"
sleep 10

@browser.goto 'http://www.deelay.me/100'
p "Number of windows#{@browser.windows.size}"

@browser.window(title: 'closeable window')
@browser.window(title: 'closeable window')
@browser.switch
end




def sample7

# letters = ("A".."Z").to_a << '0'
# p letters
# letters.each do |letter|
#
# end

# gsa_a.browser.driver.window_handles.each { |handle| gsa_a.browser.driver.switch_to.window(handle) }
#gsa_a.browser.driver.window_handles.each_index  do |i|
#	p i
# use_tab(gsa_a.browser,i)
# gsa_a.browser.windows.each_index do |i|
# gsa_a.browser.window(index: i).use do
# parse_mfr_list(gsa_a.mft_table_element.html)
#end


	 # --------------------------------------------

	 # p Select::FSSI
# caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"binary" => [ "C:\\Users\\Brian\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe" ]})

 # Selenium::WebDriver::Chrome.binary = chromedriver_path
# C:\Program Files (x86)\Google\Chrome\Application\chrome.exe

# disable-infobars argument from ChromeOptions
ADV::Pages.each_value do |page|
	p page
end


letters = ("A".."Z").to_a << '0'
p letters
letters.each do |letter|
	ADV::Categories.each do |category|
		"https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4#{category}*&listFor=#{letter}"
	end
end
end

p
# p Socket.ip_address_list.any? {|addr| addr.to_s.include? "bb82"}
# p Socket.ip_address_list.any? {|addr| addr.to_s.include? "bb82"}
#   Socket.ip_address_list.each {|add| p add}


def sample8

# Selenium::WebDriver::Chrome.path = 'C:\Users\Brian\AppData\Local\Google\Chrome SxS\Application\chrome.exe'
#  browser = Watir::Browser.new :chrome
browser = Watir::Browser.new :chrome
browser.goto 'chrome://version/'
# puts browser.text
window = []

window[0] = new browser.window(browser.driver,index: 0)

p browser.driver.execute_script("window.open('https://govconsvcs.com/');")
p browser.driver.execute_script("window.open('https://www.reddit.com/r/HighQualityGifs/');")
browser.driver.execute_script("window.open('https://govconsvcs.com/gsa-schedule/what-is-a-gsa-schedule/');")
browser.driver.execute_script("window.open('https://govconsvcs.com/');")




p browser.windows.inspect
		# browser.driver.switchTo.window(tab1)
browser.driver.execute_script("window.open('https://www.google.com');")
browser.goto 'https://www.govconsvcs.com/'



#main > article > div > ul:nth-child(2) > li

 	browser.divs(css: '*').each do |element|
 		p "#{element.inspect}:\t#{element.text}"
	      # element.flash(color: "green",  outline: TRUE )
	      element.flash
	      browser.execute_script "arguments[0].style.borderRadius = '25px';
							arguments[0].style.margin = '10px 10px 10px 10px';
							arguments[0].style.padding = '10px 10px 10px 10px';
							arguments[0].style.outline = '5px dotted green';
							arguments[0].appendChild(document.createTextNode(arguments[0]));", element,element.inspect
 	end


end

#

# mycanary = "C:\\Users\\Brian\\AppData\\Local\\Google\\Chrome SxS\\Application\\chrome.exe"
# browser = Watir::Browser.start('https://www.reddit.com/',:chrome , switches:%w(headless disable-gpu))
#
# 	browser.divs(css: '.entry').each do |element|
# 		puts "#{element.text}\n"
# 	end


#

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

# ==================================================================================================================== #

# ==================================================================================================================== #

