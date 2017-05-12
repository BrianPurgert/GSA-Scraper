require 'colorize'
require 'colorized_string'
require 'in_threads'
require 'page-object'
require 'page-object/page_factory'
require 'watir'
require 'yaml'
require_relative 'mft_db'
require_relative 'pages/gsa_advantage_page'

gsa_advantage = []
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))

ARGV.each do|a|
	puts "Argument: #{a}"
end


def search_url(mfr_href_name, current_lowest_price,page_number)
	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
	url = url + "q=28:5#{mfr_href_name}"
	url = url + "&q=14:7#{current_lowest_price}"# show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + "&s=9" # sort by price high to how
	url = url + "&p=#{page_number}"
	puts "#{url}".colorize(String.colors.sample)
	return url
end

def product_url()
	# https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?gsin=11000005818274&cview=true
	url = "https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?"
	url = url + "q=28:5#{mfr_href_name}"
	url = url + "&q=14:7#{current_lowest_price}"# show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + "&s=9" # sort by price high to how
	url = url + "&cview=true"
	puts "#{url}".colorize(String.colors.sample)
	return url


end


def move_to_screen(browser,screen_n)
	gsm=Fiddle::Function.new(Fiddle::dlopen("user32")["GetSystemMetrics"],[Fiddle::TYPE_LONG],Fiddle::TYPE_LONG)
	x= gsm.call(0)
	y= gsm.call(1)
	browser.driver.manage.window.move_to(x+screen_n, 0)
end

def split_screen(browser,split,pos_h,pos_v)
	gsm=Fiddle::Function.new(Fiddle::dlopen("user32")["GetSystemMetrics"],[Fiddle::TYPE_LONG],Fiddle::TYPE_LONG)
	x= gsm.call(0)
	y= gsm.call(1)
	browser.driver.manage.window.move_to(x*pos_h, y*pos_v)
	browser.driver.manage.window.resize_to(x*split,y*split)
end


def initialize_browser
		r_proxy = Proxy_list.sample
		browser       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage = GsaAdvantagePage.new(browser)

		move_to_screen(gsa_advantage.browser,-1)
		split_screen(gsa_advantage.browser,0.5,0,1)
		gsa_advantage.goto
		if gsa_advantage.browser.text.include?('This site can’t be reached')
			raise 'Site cannot be reached'
		end
end