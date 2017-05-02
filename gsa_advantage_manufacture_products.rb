require 'watir'
require 'page-object/page_factory'
require 'page-object'
require 'spreadsheet'
require_relative 'pages/gsa_advantage_page'
require 'colorize'
require 'colorized_string'
require 'mysql2'
require 'monetize'
require 'yaml'
require 'in_threads'

Bench_time    = [Time.now]
browser       = []
gsa_advantage = []
@mfr_table    = []
@speed = 5

N_threads = 1
N_threads_plus_one = N_threads+1
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))

@client = Mysql2::Client.new(
host:     "70.61.131.180",
username: "mft_data",
password: "GoV321CoN",
reconnect: true,
cast: false
)

def load_table_mfr
	result = @client.query('SELECT * FROM `mft_data`.`mfr` ORDER BY last_updated;')
	result.each do |row|
		@mfr_table  << row
	end
	@mfr_table.each do |mfr|
		 print "#{mfr['name']}\t".colorize(:white)
		 print "#{mfr['href_name']}\t".colorize(:magenta)
		 print "#{mfr['last_updated']}\t".colorize(:blue)
		 puts "#{mfr['item_count']}\t".colorize(:green)
	end
end

def xls_to_database(client)
    insert_mfr_part = client.prepare('
INSERT IGNORE INTO `mft_data`.`lowest_price_contractor`(mpn, manufacturer_name)
VALUES (?, ?);
')
    @href_name.each_index do |mfr_index|
	  print "#{mfr_index}\t".colorize(:magenta)
	  puts "#{@href_name[mfr_index]}\t\t\t#{@mfr_name[mfr_index]}".colorize(:cyan)
	  insert_mfr_part.execute(@href_name[mfr_index], @mfr_name[mfr_index])
    end
end

def skip(search_item)
    puts "skipping MFT: #{search_item}"
end

def benchmark
    Bench_time << Time.now
    elapsed       = Bench_time[-1] - Bench_time[-2]
    total_elapsed = Bench_time[-1] - Bench_time[0]
    print "\tElapsed: #{total_elapsed}\tSince Last: #{elapsed}\n".colorize(:blue)
end
# def move_empty_queue
# 	@client.query('
# UPDATE `mft_data`.`lowest_price_contractor`, `mft_data`.`queue`
# SET lowest_price_contractor.lowest_contractor = queue.lowest_contractor,
#     lowest_price_contractor.lowest_contractor_price = queue.lowest_contractor_price,
#     lowest_price_contractor.lowest_contractor_page_url = queue.lowest_contractor_page_url,
#     lowest_price_contractor.mpn_page_url = queue.mpn_page_url
# WHERE lowest_price_contractor.mpn = queue.mpn;
# ')
# 	@client.query('TRUNCATE `mft_data`.`queue`;')
# end

# &q=14:6#{more_than_price}
# &q=14:7#{less_than_price}


#TODO search url
def search_url(mfr_href_name, current_lowest_price,page_number)
	url = "https://www.gsaadvantage.gov/advantage/s/search.do?"
	url = url + "q=28:5#{mfr_href_name}"
	url = url + "&q=14:7#{current_lowest_price}"# show price lower than current_lowest_price
	url = url + "&&c=100"# sort by price highest to lowest
	url = url + "&s=9" # sort by price high to how
	url = url + "&p=#{page_number}"
	return url

end

def initialize_browsers(browser, gsa_advantage)
	down = 0
	(1..N_threads).in_threads.each do |nt|
		r_proxy = Proxy_list.sample
		browser[nt]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage[nt] = GsaAdvantagePage.new(browser[nt])
		# gsa_advantage[nt].browser.goto 'https://ifconfig.co/ip'
		print "\nBrowser #{nt}\t".colorize(:blue)
		print "#{gsa_advantage[nt].browser.text}\t#{r_proxy}"
		gsa_advantage[nt].browser.driver.manage.window.resize_to(300, 300)
		
		gsa_advantage[nt].browser.driver.manage.window.move_to((nt/N_threads*1600), 0)
		gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov'
		if gsa_advantage[nt].browser.text.include?('This site can’t be reached')
			puts 'down'
			down = down + 1
		end
		puts gsa_advantage[nt]
	end
	puts "down count:\t#{down}"
	if(down > 3)
		exit
	end
end

def scrape_manufactures(browser, gsa_advantage)
	rx_mfr = /(?<=\q=28:5).*/
	("A".."Z").in_threads(2).each_with_index do |letter, index|
		r_proxy = Proxy_list.sample
		browser[index]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage[index] = GsaAdvantagePage.new(browser[index])
		gsa_advantage[index].browser.goto "https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4*&listFor=#{letter}"
		@href_mfrs = []
		gsa_advantage[index].mft_table_element.links.each do |link|
			href_mfr = rx_mfr.match(link.href)
			puts href_mfr
			@href_mfrs << href_mfr
		end
	end
end

#TODO search manufacture
def search_on_browser(gsa_advantage, mfr)
     puts "Search Start:\t#{mfr['name']}"
     @current_lowest_price = 900000000
     @has_more_pages = false
     While @has_more_pages do
          @current_search = search_url(mfr['name'], current_lowest_price,1)
	gsa_advantage.browser.goto @current_search
          #TODO check has_more_pages
          #TODO get page links
	if gsa_advantage.first_result_element.exist?
		gsa_advantage.first_result
		product_page_url = gsa_advantage.current_url
		if gsa_advantage.contractor_highlight_link_element.exist? && gsa_advantage.contractor_highlight_price_element.exists?
			contractor          = gsa_advantage.contractor_highlight_link_element.text
			contractor_price    = gsa_advantage.contractor_highlight_price
			contractor_page_url = gsa_advantage.contractor_highlight_link_element.href
				@semaphore.synchronize{
					update_mfr.execute(si,contractor, contractor_price, contractor_page_url, product_page_url)
				}
				puts "MPN:\t#{si}\tMSG:\t#{e.message}"
		else
			puts 'DO SOMETHING HERE'
		end
	else
		puts "Search #{si} returned no items"
     end

     end
end

# move_empty_queue
load_table_mfr
initialize_browsers(browser, gsa_advantage)
puts "\n------------------------\n------------------------\n".colorize(:orange)

# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=14:790000000&searchType=0&s=9&c=100 $3,800,470.59
# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=14:73800470&searchType=0&s=9&c=100 $1,714,588.24
# https://www.gsaadvantage.gov/advantage/s/search.do?q=28:53M&q=14:71714588&searchType=0&s=9&c=100
# ...
# ...
# https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?gsin=11000012297910&cview=true


@semaphore = Mutex.new
@threads = []
t_count = 0;

@mfr_table.each_index do |index|
     puts @mfr_table[index]
     exit
    thr_n = index % N_threads_plus_one
	    t_count = t_count+1
	    @threads << Thread.new do
		    search_on_browser(gsa_advantage[thr_n], @mfr_table[index])
              sleep @speed
	    end
    if t_count >= N_threads
	    @threads.each { |t| t.join if t != Thread.current }
	    t_count = 0
    end
end
puts 'Joining Threads'
Thread.list.each { |t| t.join if t != Thread.current }




















