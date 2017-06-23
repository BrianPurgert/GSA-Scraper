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

def bp(arr_str,length = [50,50,50,50,50,50,50])
	out_str = ""
	arr_str.each_with_index do |str, i|
		out_str += "|#{(str + ' ' * length[i])[0, length[i]]}|".colorize(String.colors[i])
	end
	puts out_str
end

def vendor_url(url_encoded_name, current_lowest_price,category,page_number=1,high_low=true)
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=1:4ADV.ELE*&q=14:7900000000&c=100&s=9&p=1
	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
	url = url + "q=28:5#{url_encoded_name}"
	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + (high_low ? '&s=9' : '&s=6')
	url = url + "&q=1:4#{category}*"
	url = url + "&p=#{page_number}"
	# puts url
	return url
end

def search_url(url_encoded_name, current_lowest_price,category,page_number=1,high_low=true)
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=1:4ADV.ELE*&q=14:7900000000&c=100&s=9&p=1
	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
	url = url + "q=28:5#{url_encoded_name}"
	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + (high_low ? '&s=9' : '&s=6')
	url = url + "&q=1:4#{category}*"
	url = url + "&p=#{page_number}"
	# puts url
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

def initialize_agent
	proxy       = Proxy_list.sample.partition(":")
	puts proxy.inspect
	url         = 'https://www.gsaadvantage.gov/advantage/search/headerSearch.do'
	agent =  Mechanize.new do |a|
		a.set_proxy proxy[0], proxy[2]
		a.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.82 Safari/537.36"
		a.follow_meta_refresh = true
	end
	agent.get(url)
	return agent
end

def restart_browser(gsa_a)
	gsa_a.browser.close
	return initialize_browser
end

def initialize_browser
	begin
		return initialize_browser_s
	rescue Exception => e
		puts e.message
		return initialize_browser_s
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
	html = HtmlBeautifier.beautify(html)
	short_url = ''

	if url.include? 'search.do'
		ph_h = Catalog_hudson+ "/catalog/"+"#{file_name}"+".html"
		pt_h = Catalog_hudson+ "/catalog/"+"#{file_name}"+".txt"
		ph = "R:/s/"+"#{file_name}"+".html"
		pt = "R:/s/"+"#{file_name}"+".txt"

	elsif url.include? 'product_detail.do'
		split_url = "#{url}".chomp('&cview=true')
		split_url.each_line('=') { |s| short_url = s if s.include? '11' }

		ph_h = Catalog_hudson+ "/catalog/"+"#{short_url}"+".html"
		pt_h = Catalog_hudson+ "/catalog/"+"#{short_url}"+".txt"
		ph = "R:/catalog/"+"#{short_url}"+".html"
		pt = "R:/catalog/"+"#{short_url}"+".txt"
	end
	open(ph_h, 'w') { |f| f.puts html }
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