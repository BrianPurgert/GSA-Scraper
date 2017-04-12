require 'page-object'
require 'watir'
require 'page-object/page_factory'
require 'page-object'
require 'spreadsheet'
require_relative 'pages/gsa_advantage_page'
require 'colorize'
require 'colorized_string'
require 'mysql2'
require 'monetize'

Bench_time = [Time.now]
browser       = []
gsa_advantage = []
@search_items = []
@mfr_name = []

def ask_user
		puts "0:\t Run GSA Advantage search on items from database".colorize(:cyan)
		puts "1:\t Add excel data to database only".colorize(:cyan)
		puts "2:\t Add excel data to database and run GSAAdvantage search on items from database".colorize(:cyan)
		puts "3:\t Add all excel files in directory to database".colorize(:cyan)
		user_value = gets.to_i
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
						@search_items << row[@mfr_col].to_s
				end
				if @mfrn_found == true && !row[@mfrn_col].nil?
						@mfr_name << row[@mfrn_col].to_s
				end
				row.each_with_index do |col, c_index|
						cell = col.to_s.downcase
						if cell.include?('mfr part') || cell.include?('manufacturer part') || cell.include?('mpn')
								@mfr_col   = c_index
								@mfr_row   = r_index
								@mfr_found = true
								puts "MPN Found at:#{@mfr_col} #{@mfr_row}"
						end
						if cell.include?('mfr name') || cell.include?('manufacturer name') || (cell.include?('mfr') && !cell.include?('part'))
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
		
		@search_items.each_index do |mfr_index|
				print "#{mfr_index}\t".colorize(:magenta)
				puts "#{@search_items[mfr_index]}\t\t\t#{@mfr_name[mfr_index]}".colorize(:cyan)
				insert_mfr_part.execute(@search_items[mfr_index], @mfr_name[mfr_index])
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
		@data_out[search_item] = ['SKIPPED', 'SKIPPED', 'SKIPPED', 'SKIPPED']
		puts "skipping MFT: #{search_item}"
end
def benchmark
		Bench_time << Time.now
		elapsed = Bench_time[-1] - Bench_time[-2]
		total_elapsed = Bench_time[-1] - Bench_time[0]
		print "\tElapsed: #{total_elapsed}\tSince Last: #{elapsed}\n".colorize(:blue)
end
def search_url(mpn, mft)
		return "https://www.gsaadvantage.gov/advantage/s/search.do?q=9,8:0#{mpn}&q=10:2#{mft}&s=0&c=25&searchType=0"
end
def initialize_browsers(browser, gsa_advantage, proxy_list)
		proxy_list.each_with_index do |proxy, index|
				benchmark
				browser[index]       = Watir::Browser.new :chrome, switches: ["--proxy-server=#{proxy}"]
				gsa_advantage[index] = GsaAdvantagePage.new(browser[index])
				gsa_advantage[index].browser.goto 'https://ifconfig.co/ip'
				print "\nProxy #{index}\t"
				print "#{gsa_advantage[index].browser.text}\t#{proxy}"
				benchmark
				gsa_advantage[index].browser.driver.manage.window.resize_to(300, 950)
				gsa_advantage[index].browser.driver.manage.window.move_to(((index % 8)*200), 0)
				gsa_advantage[index].browser.goto 'https://www.gsaadvantage.gov'
				benchmark
		end
end


proxy_list = %w(
  155.254.183.52:60099
  155.254.183.63:60099
  155.254.183.67:60099
  155.254.183.73:60099
  104.151.234.179:8080
  104.151.234.180:8080
  104.151.234.181:8080
  104.151.234.182:8080
)


client = Mysql2::Client.new(
		host:       "70.61.131.180",    username:   "mft_data",
		password:   "GoV321CoN",        flags:      Mysql2::Client::MULTI_STATEMENTS)



user_value = ask_user
case user_value
		when 0
				puts 'Skipping XLS read'
		when 1
				output_xls = xls_read
				xls_to_database(client)
		when 2
				output_xls = xls_read
				xls_to_database(client)
	
end


result = client.query('
SELECT *
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')

result.each_with_index  do |row, index|
		# puts row["mpn"]
		@search_items << row['mpn']
		@mfr_name << row['manufacturer_name']
		print "\t#{index}\t".colorize(:magenta)
		puts "\t#{@search_items[index]}\t#{@mfr_name[index]}".colorize(:cyan)
end


update_mfr = client.prepare("
UPDATE mft_data.lowest_price_contractor
SET lowest_contractor = ?,
lowest_contractor_price = ?,
lowest_contractor_page_url = ?,
mpn_page_url = ?
WHERE mpn = ?
;")


initialize_browsers(browser, gsa_advantage, proxy_list)
puts "_____________________________________________________________________________".colorize(:orange)
@data_out = {}
		@search_items.each_index do |index|
				browser_n = index % proxy_list.size
				unless gsa_advantage[browser_n].current_url.include? @search_items[index]
						threads = []
						(0..6).each do |thr_n|
								if (index+thr_n) < @search_items.size
								threads << Thread.new {gsa_advantage[((index+thr_n) % proxy_list.size)].browser.goto search_url(@search_items[(index+thr_n)], @mfr_name[(index+thr_n)])}
								end
						end
						threads.each { |thr| thr.join }
				else
						puts "URL Contained:\t#{@search_items[index]}"
				end
				unless gsa_advantage[browser_n].first_result_element.exist?
						skip @search_items[index];	next # should search again
				end
				gsa_advantage[browser_n].first_result
				product_page_url = gsa_advantage[browser_n].current_url
				unless gsa_advantage[browser_n].contractor_highlight_link_element.exist? && gsa_advantage[browser_n].contractor_highlight_price_element.exists?
						skip @search_items[index]; next
				end
				contractor = gsa_advantage[browser_n].contractor_highlight_link_element.text
				contractor_price = gsa_advantage[browser_n].contractor_highlight_price
				contractor_price = Monetize.parse(contractor_price)
				contractor_page_url = gsa_advantage[browser_n].contractor_highlight_link_element.href
				# puts contractor_page_url
				@data_out[@search_items[index]] = [@mfr_name[index],contractor, contractor_price, contractor_page_url, product_page_url]
				update_mfr.execute(contractor, contractor_price, contractor_page_url, product_page_url,@search_items[index])
				print "#{@search_items[index]}\t|\t#{index}\t/\t#{@search_items.size}"
				benchmark
		end
@data_out.each { |key, value|
		puts "#{key}\t#{value[0]}\t#{value[1]}\t#{value[2]}\t#{value[3]}\t#{value[4]}"
}


write_new_xls(output_xls)














