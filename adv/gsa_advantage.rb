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
require 'mechanize'
require_relative '../config/adv_scrape'
require_relative 'adv_parse'
require_relative File.dirname(__FILE__) + '/../database/mft_db'
require_relative File.dirname(__FILE__) + '/../pages/gsa_advantage_page'


# :black   => 0, :light_black    => 60,
# :red     => 1, :light_red      => 61,
# :green   => 2, :light_green    => 62,
# :yellow  => 3, :light_yellow   => 63,
# :blue    => 4, :light_blue     => 64,
# :magenta => 5, :light_magenta  => 65,
# :cyan    => 6, :light_cyan     => 66,
# :white   => 7, :light_white    => 67,
# :default => 9

def color_p(str,i=-1)
	case i
		when -1
			out_color = [:light_cyan,:green, :yellow,:light_yellow].sample
		else
			out_color = String.colors[i]
	end
	puts "#{str}".colorize(out_color)
end


# GS-27F-035BA
def search_url(url_encoded_name, current_lowest_price,category,page_number=1,high_low=true)
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=0:0 GS-27F-0012U &db=0&searchType=1 V797P-4109B
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=0:0 GS-27F-0012U &db=0&searchType=0
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=19:2 GS-21F-0072Y&s=6&c=100&searchType=1
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=1:4ADV.ELE*&q=14:7900000000&c=100&s=9&p=1
	# https://www.gsaadvantage.gov/advantage/s/search.do?q=24:2 RJ%27S%20SUPPLY%20COMPANY,%20LLC &s=0&c=25&searchType=1
	
	url         = "#{GSA_ADVANTAGE}/advantage/s/search.do?"
	search_in   = 'manufacture'
	search_type = '1'
	case @search_in
		when 'manufacture'
			url = url + 'q=28:5'
		when 'contract'
			url = url + 'q=19:2'
		when 'contractor'
			url = url + 'q=24:2'
	end
	url = url + "#{url_encoded_name}"
	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + (high_low ? '&s=9' : '&s=6')
	url = url + (IGNORE_CAT ? '' : "&q=1:4#{category}*")
	# url = url + "searchType=#{search_type}"
	url = url + "&p=#{page_number}"
	# puts url
	# todo save to db
	return url
end

def gsin_url
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
	proxy      = PROXY_LIST.sample.partition(":")
	user_agent = Mechanize::AGENT_ALIASES.keys.sample
	url        = "https://www.gsaadvantage.gov/advantage/search/headerSearch.do"
	agent      = Mechanize.new
	if LOGWEB
		(agent.log = Logger.new ($stdout))
	end
	
	agent.user_agent_alias = user_agent
	agent.set_proxy proxy[0], proxy[2]
	response = agent.get(url)
	puts "#{proxy[0]} #{response.code}"
	
	return agent
end

def restart_browser(gsa_a)
	gsa_a.browser.close
	return initialize_browser
end

def initialize_browser
	begin
		MECHANIZED ? (return initialize_agent) : (return initialize_browser_s)
	rescue Exception => e
		puts e.message
		MECHANIZED ? (return initialize_agent) : (return initialize_browser_s)
	end
end

def initialize_browser_s
	r_proxy      = PROXY_LIST.sample
		options = Selenium::WebDriver::Chrome::Options.new(args: ["headless", "disable-gpu","proxy-server=#{r_proxy}"])
		browser = Watir::Browser.start 'https://www.gsaadvantage.gov/advantage/search/headerSearch.do', :chrome, options: options
		gsa_a   = GsaAdvantagePage.new(browser)
		unless gsa_a.title.include? 'Welcome to GSA Advantage!'
			raise 'Welcome to GSA Advantage! not in title'
		end
		puts "#{gsa_a.title} | #{r_proxy} | ".colorize(:blue)
		return gsa_a
end

def get_html(gsa_a, n, url)
	if MECHANIZED then
		begin
			page = gsa_a[n].get url
		rescue
			gsa_a[n] = initialize_browser
			page = gsa_a[n].get url
		end
		if page.code == 200
			color_p "Agent #{n} received Code: #{page.code}", 7
		end
		# 503 => Net::HTTPServiceUnavailable
		html = page.body
	else
		gsa_a[n].browser.goto url
		html = gsa_a[n].html
	end
	save_page(html, url) if DOWNLOAD
	return html
end

def get_urls(gsa_a, n, url)
  url
  html      = get_html(gsa_a, n, url)
  doc       = Nokogiri::HTML(html)
  contractors = doc.css(CONTRACTOR_INFO)


  return
end

def save_page(html, url, file_name="")
	 # html = HtmlBeautifier.beautify(html)
		puts 'saving page'
	short_url = ''

	if url.include? 'search.do'
		url.chomp!('&c=100&s=9&p=1')
		file_name = url.split(':')
		
		ph = "C:/s/"+"#{file_name[1]}#{file_name.last}"+".html"
		pt = "C:/s/"+"#{file_name}"+".txt"

	elsif url.include? 'product_detail.do'
		short_url = gsin(url)
		
		ph_h = HUDSON_LOCAL+ "/catalog/"+"#{short_url}"+".html"
		ph   = "C:/catalog/"+"#{short_url}"+".html"
	
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