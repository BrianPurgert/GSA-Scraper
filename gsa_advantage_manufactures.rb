require 'watir'
require 'page-object/page_factory'
require 'page-object'
require_relative 'pages/gsa_advantage_page'
require 'colorize'
require 'colorized_string'
require 'mysql2'
require 'yaml'
require 'in_threads'
require_relative 'mft_db'

N_threads = 10
N_threads_plus_one = N_threads+1
@browser_threads = (0..N_threads)
browser       = []
gsa_advantage = []
RX_mfr = /(?<=\q=28:5).*/
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))
# @search_items = []
# @mfr_name     = []




@hudson_db = MftDb.new

def initialize_browsers(browser, gsa_advantage)
	@browser_threads.in_threads.each do |nt|
		r_proxy = Proxy_list.sample
		browser[nt]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage[nt] = GsaAdvantagePage.new(browser[nt])
		print "\nBrowser #{nt}\t".colorize(:blue)
		print "#{gsa_advantage[nt].browser.text}\t#{r_proxy}\t"
		puts gsa_advantage[nt]
		gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov'

	end
end

def scrape_mft_step_1(index,gsa_advantage)
		@mfrs = []
		@href_mfrs = []
		gsa_advantage.mft_table_element.links.each do |link|
			@href_mfr = RX_mfr.match(link.href)
			@name_mfr = link.text
			# @parent_mfr = link.parent
			@hudson_db.insert_mfr(@name_mfr,@href_mfr)
			# @href_mfrs << @href_mfr
			# puts @href_mfr
		end
		
	# @semaphore.synchronize{
	# 	puts '1'
	# 	# @href_mfrs
	# 	# mfr_mysql.execute(name, href_name, item_count)
	# }
	
end
#  next step load the parts
# "https://www.gsaadvantage.gov/advantage/s/search.do?q=1:4*&s=4&c=100&q=28:5#{href_mfr}"

initialize_browsers(browser, gsa_advantage)

@semaphore = Mutex.new
@threads = []
@mfr_list = ("A".."F").to_a << "0"

@mfr_list.in_threads.each_index do |index|
	    # @threads << Thread.new do
		    scrape_mft_step_1(index, gsa_advantage)
	    # end
end
puts 'Threads launced waiting to complete'
Thread.list.each { |t| t.join if t != Thread.current }
puts 'Errors or na?'






