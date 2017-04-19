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

browser       = []
gsa_advantage = []
RX_mfr = /(?<=\q=28:5).*/
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))

@client = Mysql2::Client.new(
host:     "70.61.131.180",
username: "mft_data",
password: "GoV321CoN",
reconnect: true,
cast: false
)






def move_empty_queue
	@client.query('
UPDATE `mft_data`.`lowest_price_contractor`, `mft_data`.`queue`
SET lowest_price_contractor.lowest_contractor = queue.lowest_contractor,
    lowest_price_contractor.lowest_contractor_price = queue.lowest_contractor_price,
    lowest_price_contractor.lowest_contractor_page_url = queue.lowest_contractor_page_url,
    lowest_price_contractor.mpn_page_url = queue.mpn_page_url
WHERE lowest_price_contractor.mpn = queue.mpn;
')
	@client.query('TRUNCATE `mft_data`.`queue`;')
end


mfr_mysql = @client.prepare("INSERT IGNORE INTO mft_data.mfr(name, href_name, item_count) VALUES (?, ?, ?)")


def scrape_mft_step_1(mfr_mysql,index)
	
		@r_proxy = Proxy_list.sample
		@browser       = Watir::Browser.new :chrome, switches: ["proxy-server=#{@r_proxy}"]
		@gsa_advantage = GsaAdvantagePage.new(@browser)
		@gsa_advantage.browser.goto "https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4*&listFor=#{@mfr_list[index]}"
		@mfrs = []
		@href_mfrs = []
		@gsa_advantage.mft_table_element.links.each do |link|
			@href_mfr = RX_mfr.match(link.href)
			@name_mfr = link.text
			# @parent_mfr = link.parent
			@href_mfrs << @href_mfr
			puts @href_mfr
		end
		
	# @semaphore.synchronize{
	# 	puts '1'
	# 	# @href_mfrs
	# 	# mfr_mysql.execute(name, href_name, item_count)
	# }
	
end
#  next step load the parts
# "https://www.gsaadvantage.gov/advantage/s/search.do?q=1:4*&s=4&c=100&q=28:5#{href_mfr}"


@semaphore = Mutex.new
@threads = []
@mfr_list = ("A".."F").to_a << "0"

@mfr_list.in_threads.each_index do |index|
	    # @threads << Thread.new do
		    scrape_mft_step_1(mfr_mysql,index)
	    # end
end
puts 'Threads launced waiting to complete'
Thread.list.each { |t| t.join if t != Thread.current }
puts 'Errors or na?'






