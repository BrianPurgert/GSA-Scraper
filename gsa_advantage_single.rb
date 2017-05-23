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

Bench_time         = [Time.now]
browser            = []
gsa_advantage      = []
@href_name         = []
@mfr_name          = []
N_threads          = 10
N_threads_plus_one = N_threads+1
Proxy_list         = YAML::load_file(File.join(__dir__, 'proxy.yml'))
@client            = Mysql2::Client.new(
host:     "70.61.131.180",
username: "mft_data",
password: "GoV321CoN",
reconnect: true,
cast: false
)

def ask_user
    user_value = 0
	    # user_value = gets.to_i
end
def xls_read
    Spreadsheet.client_encoding = 'UTF-8'
    basedir                     = './../Input-Files/'
    files                       = Dir.glob(basedir+"*.xls")
    files.each_with_index do |file, num|
	  puts "#{num}\t#{file}\t".colorize(:green)
    end
    pick_num   = gets.to_i
    book       = Spreadsheet.open files[pick_num]
    output_xls = "#{files[pick_num]}-out.xls"
    sheet      = book.worksheet 0
    
    @mfr_found  = false
    @mfrn_found = false
    sheet.each_with_index do |row, r_index|
	  if @mfr_found == true && !row[@mfr_col].nil?
		@href_name << row[@mfr_col].to_s
	  end
	  if @mfrn_found == true && !row[@mfrn_col].nil?
		@mfr_name << row[@mfrn_col].to_s
	  end
	  row.each_with_index do |col, c_index|
		cell = col.to_s.downcase
		if cell.include?('mfr part') || cell.include?('manufacturer part') || cell.include?('mpn') || cell.include?('mfgpart')
		@mfr_col   = c_index
		    @mfr_row   = r_index
		    @mfr_found = true
		    puts "MPN Found at:#{@mfr_col} #{@mfr_row}"
		end
		if cell.include?('mfr name') || cell.include?('manufacturer name') || cell.include?('mfgname') || (cell.include?('mfr') && !cell.include?('part'))
		    @mfrn_col   = c_index
		    @mfrn_row   = r_index
		    @mfrn_found = true
		    puts "Mft Found at:#{@mfrn_col} #{@mfrn_row}"
		end
	  end
    end
    output_xls
    puts @mfrn_found ? "Manufacture found".colorize(:green) : 'Manufacture not found'.colorize(:red)
    exit if !@mfrn_found
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
def write_new_xls(output_xls)
    out_book    = Spreadsheet::Workbook.new
    sheet1      = out_book.create_worksheet
    sheet1.name = 'Lowest Price Contractor'
    row_1       = ['mpn', 'manufacturer_name', 'lowest_contractor', 'lowest_contractor_price', 'lowest_contractor_page_url', 'mpn_page_url']
    out_book.worksheet(0).insert_row(0, row_1)
    @data_out.each { |key, value|
	  lst = out_book.worksheet(0).last_row_index + 1
	  out_book.worksheet(0).insert_row(lst, [key, value[0], value[1], value[2], value[3], value[4]])
    }
    out_book.write(output_xls)
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
def search_url(mpn, mft)
    return "https://www.gsaadvantage.gov/advantage/s/search.do?q=9,8:0#{mpn}&q=10:2#{mft}&s=0&c=25&searchType=0"
end
def initialize_browsers(browser, gsa_advantage)
	(0..N_threads).in_threads.each do |nt|
		r_proxy = Proxy_list.sample
		browser[nt]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
		gsa_advantage[nt] = GsaAdvantagePage.new(browser[nt])
		# gsa_advantage[nt].browser.goto 'https://ifconfig.co/ip'
		print "\nBrowser #{nt}\t".colorize(:blue)
		print "#{gsa_advantage[nt].browser.text}\t#{r_proxy}"
		gsa_advantage[nt].browser.driver.manage.window.resize_to(300, 950)
		gsa_advantage[nt].browser.driver.manage.window.move_to(((nt % 8)*200), 0)
		gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov'
		puts gsa_advantage[nt]
		benchmark
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

# "https://www.gsaadvantage.gov/advantage/s/search.do?q=1:4*&s=4&c=100&q=28:5#{href_mfr}"

# move_empty_queue

def use_database_items
	result = @client.query('
SELECT *
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')
	
	result.each_with_index do |row, index| # puts row["mpn"]
		@href_name << row['mpn']
		@mfr_name << row['manufacturer_name']
		print "\t#{index}\t".colorize(:magenta)
		puts "\t#{@href_name[index]}\t#{@mfr_name[index]}".colorize(:cyan)
	end
end


user_value = ask_user
case user_value
    when 0
	  puts 'Skipping XLS read'
	  use_database_items
    when 1
	  output_xls = xls_read
	  xls_to_database(@client)
	  use_database_items
    when 2
	  output_xls = xls_read
	  xls_to_database(@client)
end




# update_mfr = @client.prepare("UPDATE mft_data.lowest_price_contractor SET lowest_contractor=?, lowest_contractor_price=?, lowest_contractor_page_url=?, mpn_page_url=? WHERE mpn = ?;")
update_mfr = @client.prepare("INSERT INTO mft_data.queue(mpn, lowest_contractor, lowest_contractor_price, lowest_contractor_page_url, mpn_page_url) VALUES (?, ?, ?, ?, ?)")

# scrape_manufactures(browser, gsa_advantage)
# sleep 200
initialize_browsers(browser, gsa_advantage)
puts "_____________________________________________________________________________".colorize(:orange)
@data_out = {}
def search_on_browser(gsa_advantage, update_mfr,si,mn)
		gsa_advantage.browser.goto search_url(si, mn)
	if gsa_advantage.first_result_element.exist?
		gsa_advantage.first_result
		product_page_url = gsa_advantage.current_url
		if gsa_advantage.contractor_highlight_link_element.exist? && gsa_advantage.contractor_highlight_price_element.exists?
			contractor          = gsa_advantage.contractor_highlight_link_element.text
			contractor_price    = gsa_advantage.contractor_highlight_price
			contractor_page_url = gsa_advantage.contractor_highlight_link_element.href
			begin
				@semaphore.synchronize{
					@data_out[si] = [mn,contractor, contractor_price, contractor_page_url, product_page_url]
					update_mfr.execute(si,contractor, contractor_price, contractor_page_url, product_page_url)
					
				}
			rescue Exception => e
				puts "MPN:\t#{si}\tMSG:\t#{e.message}"
			end
		else
			puts 'DO SOMETHING HERE'
		end
	else
		puts "Search #{si} returned no items"
	end
	
end
@semaphore = Mutex.new
@threads = []
t_count = 0;

@href_name.each_index do |index|
    thr_n = index % N_threads_plus_one
	    t_count = t_count+1
	    @threads << Thread.new do
		    search_on_browser(gsa_advantage[thr_n], update_mfr, @href_name[index], @mfr_name[index])
	    end
    if t_count >= N_threads
	    @threads.each { |t| t.join if t != Thread.current }
	    t_count = 0
    end
end
puts 'Joining Threads'
Thread.list.each { |t| t.join if t != Thread.current }



# @data_out.each { |key, value|
#     puts "#{key}\t#{value[0]}\t#{value[1]}\t#{value[2]}\t#{value[3]}\t#{value[4]}"
# }
