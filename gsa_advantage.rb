require 'benchmark'
require 'colorize'
require 'colorized_string'
require 'htmlbeautifier'
require 'in_threads'
require 'nokogiri'
require 'open-uri'
require 'page-object'
require 'page-object/page_factory'
require 'rubygems'
require 'watir'
require 'yaml'
require_relative 'adv_constants'
require_relative 'mft_db'
require_relative 'pages/gsa_advantage_page'

Mechanized        = FALSE
Dev_mode          = FALSE
IS_PROD           = TRUE  # Check out items if true
Proxy_list        = YAML::load_file(File.join(__dir__, 'proxy.yml'))
Proxy_list1       = YAML::load_file(File.join(__dir__, 'proxy1.yml'))
Socks_list        = YAML::load_file(File.join(__dir__, 'socks5_proxy.yml'))
Socks_port        = 61336
Catalog_hudson    = '//192.168.1.104/gsa_price/'
RX_mfr            = /(?<=\q=28:5).*/                                          # Regex selects manufacture name after link

p Dev_mode ? "Running in dev mode" : "Running in production mode"


def color_p(str,i=-1)
	case i
		when -1
			out_color = String.colors.sample
		else
			out_color = String.colors[i]
	end
	puts "#{str}".colorize(out_color)
end

def bp(arr_str,length = [80,80,80,80,80,80,80])
	out_str = ""
	arr_str.each_with_index do |str, i|
		out_str += "|\t#{(str + ' ' * length[i])[0, length[i]]} |".colorize(String.colors[i])
	end
	puts out_str
end

def search_url(mfr_href_name, current_lowest_price,page_number=1,high_low=true)
	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
	url = url + "q=28:5#{mfr_href_name}"
	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + (high_low ? "&s=9" : "&s=6")                      # if true sorts by price high to how
	url = url + "&p=#{page_number}"
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

def split(browser, n, total_browsers)
	p avail_height = browser.execute_script("return screen.availHeight")
	p avail_width = browser.execute_script("return screen.availWidth")
	x_part_size = avail_width/total_browsers
	browser.window.move_to(x_part_size*n, 0)
	browser.window.resize_to(x_part_size, avail_height*0.75)
end

def move_to_screen(browser,screen_n)
	gsm=Fiddle::Function.new(Fiddle::dlopen("user32")["GetSystemMetrics"],[Fiddle::TYPE_LONG],Fiddle::TYPE_LONG)
	x= gsm.call(0)
	y= gsm.call(1)
	browser.driver.manage.window.move_to(x*screen_n, 0)
end

def split_screen(browser,split,pos_h,pos_v)
	gsm=Fiddle::Function.new(Fiddle::dlopen("user32")["GetSystemMetrics"],[Fiddle::TYPE_LONG],Fiddle::TYPE_LONG)
	x= gsm.call(0)
	y= gsm.call(1)
	browser.driver.manage.window.move_to(x*pos_h, y*pos_v)
	browser.driver.manage.window.resize_to(x*split,y*split)
end

Mechanized
def initialize_browser
		r_proxy       = Proxy_list.sample
		r_socks       = Socks_list.sample
		socks         = "socks5://#{r_socks}:#{Socks_port}"
		host          = "MAP * 0.0.0.0 , EXCLUDE #{r_socks}"
		unless Mechanized
		# browser       = Watir::Browser.new :chrome, switches: ["proxy-server=#{socks}","host-resolver-rules=#{host}"]
		Dev_mode ? switch = ["proxy-server=#{r_proxy}"] : switch = ["headless", "disable-gpu","proxy-server=#{r_proxy}"]
		browser       = Watir::Browser.new :chrome, switches: switch
		gsa_a = GsaAdvantagePage.new(browser)
		gsa_a.goto
		else
			@agent[pg] =  Mechanize.new do |a|
				a.set_proxy P_list.sample, 45623
				a.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.82 Safari/537.36"
				a.follow_meta_refresh = true
			end
		end
		puts "#{gsa_a.title} | #{r_proxy} | #{}".colorize(:blue)
		unless gsa_a.title.include? 'Welcome to GSA Advantage!'
			raise 'Welcome to GSA Advantage! not in title'
		end
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
