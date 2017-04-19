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
@search_items = []
@mfr_name     = []
N_threads = 10
N_threads_plus_one = N_threads+1
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))

def info_user
	puts "\n\nSteps"
	puts "0:\t open an excel xls file (NOT XLSX) contained in the Input-Files folder".colorize(:cyan)
	puts "1:\t gets the Manufacture Part column by using the first cell containing either: mfr part, manufacturer part, mpn, mfgpart".colorize(:cyan)
	puts "2:\t gets the Manufacture Name column by using the first cell containing either: manufacturer name, mfgname, mfr part".colorize(:cyan)
	puts "3:\t open browsers, check proxies".colorize(:cyan)
	puts "4:\t perform searches on on mpn & mft to find the featured price".colorize(:cyan)
	puts "4:\t this script specifically is not able to find sale prices"
	puts "5:\t generates filename-out.xls containing this data".colorize(:cyan)


end

def xls_read
		Spreadsheet.client_encoding = 'UTF-8'
		basedir                     = './Input-Files/'
		files                       = Dir.glob(basedir+"*.xls")
		puts "\nInput file number & press enter"
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
		puts "skipping MFT PN: #{search_item}".colorize(:red)
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

info_user
output_xls = xls_read
@search_items.each_index  do |index|
	print "\t#{index}\t".colorize(:magenta)
	puts "\t#{@search_items[index]}\t#{@mfr_name[index]}".colorize(:cyan)
end
puts 'Is this data correct? y/n'
puts 'If not, exit this, fix excel file, save, close, rerun this script'

loop do
	system("stty raw -echo")
	c = STDIN.getc
	system("stty -raw echo")
	case c
		when 'y'
			puts 'Yes'
			break
		when 'n'
			puts 'No'
			exit
		else puts 'Please type "y" or "n"'
	end
end


initialize_browsers(browser, gsa_advantage)

@data_out = {}
def search_on_browser(gsa_advantage, si,mn)
	# sleep 1
	# puts "#{mn}:#{si}\t|\t/"#{@search_items.size}
	# benchmark
	# puts "Search Current thread = " + Thread.current.to_s
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
				}
			rescue Exception => e
				puts "MPN:\t#{si}\tMSG:\t#{e.message}"
			end
		else
			puts 'can not find search result'
		end
	else
		puts "Search #{si} returned no items"
	end

end

@semaphore = Mutex.new
@threads = []
t_count = 0;
@search_items.each_index do |index|
	thr_n = index % N_threads_plus_one
	t_count = t_count+1
	@threads << Thread.new do
		search_on_browser(gsa_advantage[thr_n], @search_items[index], @mfr_name[index])
	end
	if t_count >= N_threads
		@threads.each { |t| t.join if t != Thread.current }
		t_count = 0
	end
end
puts 'Threads Started'
Thread.list.each { |t| t.join if t != Thread.current }
@data_out.each { |key, value|
	puts "#{key}\t#{value[0]}\t#{value[1]}\t#{value[2]}\t#{value[3]}\t#{value[4]}"
}
write_new_xls(output_xls)


















