require 'benchmark'
require 'colorize'
require 'colorized_string'
require 'htmlbeautifier'
require 'nokogiri'
require 'open-uri'
require 'page-object'
require 'page-object/page_factory'
require 'rubygems'
require 'watir'
# require 'watir-nokogiri'
require 'yaml'
require 'logger'
require 'mechanize'
require_relative 'adv_constants'
require_relative '../database/mft_db'
require_relative '../pages/gsa_advantage_page'


def color_p(str,i=-1)
	case i
		when -1
			out_color = String.colors.sample
		else
			out_color = String.colors[i]
	end
	puts "#{str}".colorize(out_color)
end

# def vendor_url(url_encoded_name, current_lowest_price,category,page_number=1,high_low=true)
# 	# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=1:4ADV.ELE*&q=14:7900000000&c=100&s=9&p=1
# 	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
# 	url = url + "q=28:5#{url_encoded_name}"
# 	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
# 	url = url + "&c=100"
# 	url = url + (high_low ? '&s=9' : '&s=6')
# 	url = url + "&q=1:4#{category}*"
# 	url = url + "&p=#{page_number}"
# 	# puts url
# 	return url
# end

def search_url(url_encoded_name, current_lowest_price,category,page_number=1,high_low=true)
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=1:4ADV.ELE*&q=14:7900000000&c=100&s=9&p=1
	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
	url = url + "q=28:5#{url_encoded_name}"
	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + (high_low ? '&s=9' : '&s=6')
	url = url + (IGNORE_CAT ? '' : "&q=1:4#{category}*")
	url = url + "&p=#{page_number}"
	# puts url
	# todo save to db
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
#
# class CSVParser < Mechanize::File
# 	attr_reader :csv
#
# 	def initialize uri = nil, response = nil, body = nil, code = nil
# 		super uri, response, body, code
# 		@csv = CSV.parse body
# 	end
# end

def initialize_agent
	proxy       = Proxy_list.sample.partition(":")
	puts proxy.inspect
	url         = "https://www.gsaadvantage.gov/advantage/search/headerSearch.do"
	agent = Mechanize.new
	# agent.log = Logger.new ($stdout)
	agent.user_agent_alias = 'Mac Safari'
	agent.set_proxy proxy[0], proxy[2]
	# page = agent.get url
	# page = Mechanize::Page.new URI.parse('http://example.com'), [], driver.page_source, 200, agent
	# puts page.body
	agent.get(url)
	return agent
end

def restart_browser(gsa_a)
	gsa_a.browser.close
	return initialize_browser
end

def initialize_browser
	begin
		Mechanized ? (return initialize_agent) : (return initialize_browser_s)
	rescue Exception => e
		puts e.message
		Mechanized ? (return initialize_agent) : (return initialize_browser_s)
	end
end

def initialize_browser_s
		r_proxy       = Proxy_list.sample
		options = Selenium::WebDriver::Chrome::Options.new(args: ["headless", "disable-gpu","proxy-server=#{r_proxy}"])
		browser = Watir::Browser.start 'https://www.gsaadvantage.gov/advantage/search/headerSearch.do', :chrome, options: options
		gsa_a = GsaAdvantagePage.new(browser)
		unless gsa_a.title.include? 'Welcome to GSA Advantage!'
			raise 'Welcome to GSA Advantage! not in title'
		end
		puts "#{gsa_a.title} | #{r_proxy} | ".colorize(:blue)
		return gsa_a
end


def save_page(html, url, file_name="")
	 # html = HtmlBeautifier.beautify(html)
	short_url = ''
file_name = rand(100000000000)
	if url.include? 'search.do'
		# split_url = "#{url}".chomp('&p=1')
		# split_url.each_line('=') { |s| file_name = s if s.include? '28' }
		ph_h = Catalog_hudson+ "/catalog/"+"#{file_name}"+".html"
		pt_h = Catalog_hudson+ "/catalog/"+"#{file_name}"+".txt"
		ph = "C:/s/"+"#{file_name}"+".html"
		pt = "C:/s/"+"#{file_name}"+".txt"

	elsif url.include? 'product_detail.do'
		split_url = "#{url}".chomp('&cview=true')
		split_url.each_line('=') { |s| short_url = s if s.include? '11' }

		ph_h = Catalog_hudson+ "/catalog/"+"#{short_url}"+".html"
		pt_h = Catalog_hudson+ "/catalog/"+"#{short_url}"+".txt"
		ph = "C:/catalog/"+"#{short_url}"+".html"
		pt = "C:/catalog/"+"#{short_url}"+".txt"
	end
	open(ph, 'w') { |f| f.puts html }
	return short_url
end

Bench_time         = [Time.now]
def benchmark name = '', completed = 1
	Bench_time << Time.now
	elapsed       = Bench_time[-1] - Bench_time[-2]
	elapsed == 0? say = " ---------- ".colorize(:blue) : say = "#{completed/elapsed} #{name} per second".colorize(:red)
	puts say
	puts elapsed
end