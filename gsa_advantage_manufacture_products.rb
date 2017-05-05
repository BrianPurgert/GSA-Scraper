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

BENCH_TIME     = [Time.now]
@browser       = []
@gsa_advantage = []
@mfr_table     = []
@speed         = 5

N_threads = 1
N_threads_plus_one = N_threads+1
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))

@client = Mysql2::Client.new(
     host:      '70.61.131.180',
     username:  'mft_data',
     password:  'GoV321CoN',
     reconnect: true,
     cast:      false
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

def benchmark
    BENCH_TIME << Time.now
    elapsed       = BENCH_TIME[-1] - BENCH_TIME[-2]
    total_elapsed = BENCH_TIME[-1] - BENCH_TIME[0]
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
	url += "&&c=100"# sort by price highest to lowest
	url = url + "&s=9" # sort by price high to how
	url = url + "&p=#{page_number}"
	return url
end

def initialize_browsers
     down = 0
	(1..N_threads).in_threads.each do |nt|
		r_proxy = Proxy_list.sample
		browser[nt]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage[nt] = GsaAdvantagePage.new(browser[nt])
		# @gsa_advantage[nt].@browser.goto 'https://ifconfig.co/ip'
		print "\nBrowser #{nt}\t".colorize(:blue)
		print "#{gsa_advantage[nt].browser.text}\t#{r_proxy}"
		gsa_advantage[nt].browser.driver.manage.window.maximize
		gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov'
		if gsa_advantage[nt].browser.text.include?('This site can’t be reached')
			puts 'down'
			down = down + 1
		end
		puts gsa_advantage[nt]
	end
	puts "down count:\t#{down}"
	if down > 3
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
	@manufacture_name             = mfr['name']
	@manufacture_href             = mfr['href_name']
	@manufacture_item_count       = mfr['item_count']
	@manufacture_product_results  = []
	@n_low                        = 900000000
	@has_more_pages               = true
		
		while @has_more_pages do
				gsa_advantage.browser.goto search_url(@manufacture_href, @n_low,1)

				gsa_advantage.browser.product_detail.each do |product_link|
					puts product_link
					# link.parent
				end
		end
end

# move_empty_queue
load_table_mfr
initialize_browsers()


@mfr_table.each_index do |index|
	sleep @speed
	puts "@gsa_advantage[0] #{@gsa_advantage[0]}     @mfr_table[index] #{@mfr_table[index]}"
	

	search_on_browser(@gsa_advantage[thr_n], @mfr_table[index])
end


# @semaphore = Mutex.new
# @threads = []
# t_count = 0;
# @mfr_table.each_index do |index|
#      puts "@mfr_table[index] #{@mfr_table[index]}"
#     thr_n = index % N_threads_plus_one
#      puts "thr_n #{thr_n}"
# 	    t_count = t_count+1
# 	    @threads << Thread.new do
#               sleep @speed
#               puts @gsa_advantage[thr_n]
#               puts thr_n
# 		    search_on_browser(@gsa_advantage[thr_n], @mfr_table[index])
#
# 	    end
#     if t_count >= N_threads
# 	    @threads.each { |t| t.join if t != Thread.current }
# 	    t_count = 0
#     end
# end
# puts 'Joining Threads'
# Thread.list.each { |t| t.join if t != Thread.current }




















