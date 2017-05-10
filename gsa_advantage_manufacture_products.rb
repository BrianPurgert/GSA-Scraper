require 'watir'
require 'page-object/page_factory'
require 'page-object'
require 'spreadsheet'
require_relative 'pages/gsa_advantage_page'
require 'colorize'
require 'colorized_string'
require 'mysql2'
require 'yaml'
require 'in_threads'
require_relative 'mft_db'

N_threads = 1
N_threads_plus_one = N_threads+1
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))

@browser       = []
@gsa_advantage = []
# @mfr_table     = []

@speed         = 0

# money = '$18.28'
# puts money
# money = money.scan(/\d+/).first
# money.map {|x| x[/\d+/]}
# puts money
# sleep 1111

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



#TODO search url
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

def initialize_browsers
     down = 0
	(1..N_threads).in_threads.each do |nt|
		r_proxy = Proxy_list.sample
		@browser[nt]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		@gsa_advantage[nt] = GsaAdvantagePage.new(@browser[nt])
		# @gsa_advantage[nt].@browser.goto 'https://ifconfig.co/ip'
		print "\nBrowser #{nt}\t".colorize(:blue)
		print "#{@gsa_advantage[nt].browser.text}\t#{r_proxy}"
          @gsa_advantage[nt].browser.driver.manage.window.move_to(2000, 100)
		@gsa_advantage[nt].browser.driver.manage.window.maximize
          size = @gsa_advantage[nt].browser.driver.manage.window.size
          pos = @gsa_advantage[nt].browser.driver.manage.window.position
          @gsa_advantage[nt].browser.driver.manage.window.resize_to(size.width,size.height/2)
          @gsa_advantage[nt].browser.driver.manage.window.move_to(pos.x, pos.y)
		@gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov'
		if @gsa_advantage[nt].browser.text.include?('This site can’t be reached')
			puts 'down'
			down = down + 1
               exit if down > 3
		end
		puts @gsa_advantage[nt]
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

def check_result_numbers(n)
     n_obj = []
     n_obj[0]                          = @gsa_advantage[n].product_detail_elements.length
     n_obj[1]                          = @gsa_advantage[n].ms_mpn_elements.length
     n_obj[2]                          = @gsa_advantage[n].ms_low_price_elements.length
     n_obj[3]                          = @gsa_advantage[n].ms_desc_elements.length
     @data_consistent                  = n_obj[0] == n_obj[1] && n_obj[0] == n_obj[2] && n_obj[0] == n_obj[3]
     puts "Data Consistent?: #{@data_consistent} length: #{n_obj[0]}"
     if @data_consistent
          return n_obj[0]
     else
          return -1
     end
end

def get_parent(mpn) pr = mpn.parent
     c                      = 0
     until pr.text.include? @manufacture_name || c == 4
          pr = pr.parent
     end
     puts pr.single_product
     pr.scroll_into_view
     pr.flash
end

# :name=>"A.O. SMITH CORP",
# :href_name=>"A.O.+SMITH+CORP",
# :last_updated=>"2017-04-21 23:11:10",
# :item_count=>"1",
# :update_count=>"0"}
def search_on_browser(n, mfr)
     # mfr = mfr[0]
     p mfr
	# puts "Search Start:\t#{mfr['name']}    gsa_advantage:\t#{@gsa_advantage[n]}"
	@manufacture_name             = mfr[:name]
	@manufacture_href             = mfr[:href_name]
	@manufacture_item_count       = mfr[:item_count]
     @n_low                        = 900000000

	begin
		@gsa_advantage[n].browser.goto search_url(@manufacture_href, @n_low,1)
		n_results            = @gsa_advantage[n].product_detail_elements.length
		result = []
		if n_results == 0
			@gsa_advantage[n].browser.refresh
			n_results            = @gsa_advantage[n].product_detail_elements.length
				# We found no Product matches for your search terms
		end
		
          
          case n_results
               when 0
                    p "No Results on #{@gsa_advantage[n].browser.url}"
	          when 1..100
			    
                    @gsa_advantage[n].product_detail_elements.each_index do |i|
                         mpn       = @gsa_advantage[n].ms_mpn_elements[i]
                         name      = @gsa_advantage[n].product_detail_elements[i].text
                         link      = @gsa_advantage[n].product_link_elements[i].href
                         price     = @gsa_advantage[n].ms_low_price_elements[i].text
                         desc      = @gsa_advantage[n].ms_desc_elements[i].text
                           # get_parent(mpn)
        
                               pr = mpn.parent.parent.parent
                              pr.scroll_into_view
                              pr.flash
                          result_set = [@manufacture_name,
                                       mpn.text,
                                       name,
                                       link,
                                       price,
                                       desc]
                          result << result_set
                          @n_low = result_set[4].scan(/\d+/).first
                    end
                        insert_mfr_parts(result)
			else
				puts "error in number of results on page, n_results: #{n_results}"
		end
	end while n_results == 100
	mfr_time(@manufacture_name)
     sleep @speed
end

# load_table_mfr
initialize_browsers()
(0..2000).each do |index|
	# puts "@gsa_advantage[1] #{@gsa_advantage[1]}     @mfr_table[index] #{@mfr_table[index]}"
     puts "Companies Processed: #{index}"
	search_on_browser(1, get_mfr)
end

# @semaphore = Mutex.new
#  @threads = []
#  t_count = 0;
# (0..2000).each do |index|
#      thr_n = index % N_threads_plus_one
#       puts "thr_n #{thr_n}"
#  	    t_count = t_count+1
#  	    @threads << Thread.new do
#  		    search_on_browser(thr_n, get_mfr)
#  	    end
#      if t_count >= N_threads
#  	    @threads.each { |t| t.join if t != Thread.current }
#  	    t_count = 0
#      end
#  end
#  Thread.list.each { |t| t.join if t != Thread.current }




















