require 'colorize'
require 'colorized_string'
require 'in_threads'
require 'page-object'
require 'page-object/page_factory'
require 'watir'
require 'yaml'
require 'benchmark'
require 'htmlbeautifier'
require_relative 'mft_db'
require_relative 'pages/gsa_advantage_page'

Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))
Catalog_hudson     = '//192.168.1.104/gsa_price/'


def color_p(str,i=-1)
	case i
		when -1
			out_color = String.colors.sample
		else
			out_color = String.colors[i]
	end
	puts "#{str}".colorize(out_color)
end

def search_url(mfr_href_name, current_lowest_price,page_number=1)
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
		r_proxy       = Proxy_list.sample
		browser       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage = GsaAdvantagePage.new(browser)
		lt = Benchmark.measure {
			gsa_advantage.goto
			gsa_advantage.wait
		}
		puts "#{gsa_advantage.title} | #{r_proxy} | #{lt}".colorize(:blue)
		unless gsa_advantage.title.include? 'Welcome to GSA Advantage!'
			raise 'Welcome to GSA Advantage! not in title'
		end
		return gsa_advantage
end

def save_page(html, url, text, file_name="")
	html = HtmlBeautifier.beautify(html, indent: "")
	short_url = ''

	if url.include? 'search.do'
		ph_hudson = Catalog_hudson+ "/catalog/"+"#{file_name}"+".html"
		pt_hudson = Catalog_hudson+ "/catalog/"+"#{file_name}"+".txt"
		ph = "R:/s/"+"#{file_name}"+".html"
		pt = "R:/s/"+"#{file_name}"+".txt"
		color_p ph,6
	elsif url.include? 'product_detail.do'
		split_url = "#{url}".chomp('&cview=true')
		split_url.each_line('=') { |s| short_url = s if s.include? '11' }

		ph_hudson = Catalog_hudson+ "/catalog/"+"#{short_url}"+".html"
		pt_hudson = Catalog_hudson+ "/catalog/"+"#{short_url}"+".txt"
		ph = "R:/catalog/"+"#{short_url}"+".html"
		pt = "R:/catalog/"+"#{short_url}"+".txt"
	end

	open(ph, 'w') { |f| f.puts html }
	open(pt, 'w') { |f| f.puts text }
	return short_url
end
