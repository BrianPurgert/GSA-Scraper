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
@search_items      = []
@mfr_name          = []
N_threads          = 5
N_threads_plus_one = N_threads+1
Proxy_list         = YAML::load_file(File.join(__dir__, 'proxy.yml'))

# Basedir_input  = 'a:/input/'
Basedir_input      = '//192.168.1.104/gsa_price/input/'
Basedir_output     = '//192.168.1.104/gsa_price/output/'
Files_input        = Dir.glob(Basedir_input+"*.xls")
Files_output       = Dir.glob(Basedir_output+"*.xls")
Current_time       = Time.new
@redo_counter      = 0


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
     puts "\nInput file number & press enter"
     Files_input.each_with_index do |file, num| puts "#{num}\t#{file}\t".colorize(:green)
     end
     # pick_num   = gets.to_i
     pick_num             = 0
     user_excel_file_name = Dir.entries(Basedir_input)
     user_excel_file_name = user_excel_file_name[2]
     puts user_excel_file_name
     book        = Spreadsheet.open Files_input[pick_num]
     sheet       = book.worksheet 0
     @mfr_found  = false
     @mfrn_found = false
     sheet.each_with_index do |row, r_index| if @mfr_found == true && !row[@mfr_col].nil?
                                                  @search_items << row[@mfr_col].to_s
                                             end
     if @mfrn_found == true && !row[@mfrn_col].nil?
          @mfr_name << row[@mfrn_col].to_s
     end
     row.each_with_index do |col, c_index| cell = col.to_s.downcase
     if cell.include?('mfr part') || cell.include?('manufacturer part') || cell.include?('mpn') || cell.include?('mfg part')
          @mfr_col   = c_index
          @mfr_row   = r_index
          @mfr_found = true
          puts "\nManufacture Part Number Found at:\t#{@mfr_col} #{@mfr_row}\n"
     end
     if cell.include?('mfr name') || cell.include?('manufacturer name') || (cell.include?('mfr') && !cell.include?('part')) || (cell.include?('manufacture') && !cell.include?('part'))
          @mfrn_col   = c_index
          @mfrn_row   = r_index
          @mfrn_found = true
          puts "\nManufacture Found at:\t#{@mfrn_col} #{@mfrn_row}\n"
     end
     end
     end
     puts @mfrn_found ? "Manufacture found".colorize(:green) : 'Manufacture not found'.colorize(:red)
     exit if !@mfrn_found
     return user_excel_file_name
end

def skip(search_item) @data_out[search_item] = ['SKIPPED', 'SKIPPED', 'SKIPPED', 'SKIPPED']
puts "skipping MFT PN: #{search_item}".colorize(:red)
end

def benchmark
     Bench_time << Time.now
     elapsed       = Bench_time[-1] - Bench_time[-2]
     total_elapsed = Bench_time[-1] - Bench_time[0]
     print "\tElapsed: #{total_elapsed}\tSince Last: #{elapsed}\n".colorize(:blue)
end

def search_url(mpn, mft) return "https://www.gsaadvantage.gov/advantage/s/search.do?q=9,8:0#{mpn}&q=10:2#{mft}&s=0&c=25&searchType=0"
end


def initialize_browsers(browser, gsa_advantage) (0..N_threads).in_threads.each do |nt| begin
     r_proxy           = Proxy_list.sample
     browser[nt]       = Watir::Browser.start 'https://www.gsaadvantage.gov/', :chrome, switches: ["proxy-server=#{r_proxy}"]
     gsa_advantage[nt] = GsaAdvantagePage.new(browser[nt])
     print "\nBrowser #{nt}\t".colorize(:blue)
     print "#{r_proxy}"
     gsa_advantage[nt].browser.driver.manage.window.resize_to(300, 950)
     gsa_advantage[nt].browser.driver.manage.window.move_to(((nt % 8)*200), 0)
     gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov/advantage/s/search.do?q=9,8:1USB-BT400'
     raise 'Cannot find result' unless gsa_advantage[nt].first_result_element.exist?
rescue Exception => e
     @redo_counter = @redo_counter + 1
     puts "Proxy:#{r_proxy}\tMSG:#{e.message}\tRedo:#{@redo_counter}"
     gsa_advantage[nt].browser.close
     redo if @redo_counter < 4
end

end
end

info_user
excel_file_out_name = "#{Basedir_output}#{Current_time.month}-#{Current_time.day}-#{Current_time.hour}-#{Current_time.min}--#{xls_read}"
puts excel_file_out_name

@search_items.each_index do |index| print "\t#{index}\t".colorize(:magenta)
puts "\t#{@search_items[index]}\t#{@mfr_name[index]}".colorize(:cyan)
end


initialize_browsers(browser, gsa_advantage)

@data_out = {}

def search_on_browser(gsa_advantage, si, mn) gsa_advantage.browser.goto search_url(si, mn)
if gsa_advantage.first_result_element.exist?
     gsa_advantage.first_result
     product_page_url = gsa_advantage.current_url
     if gsa_advantage.contractor_highlight_link_element.exist? && gsa_advantage.contractor_highlight_price_element.exists?
          contractor          = gsa_advantage.contractor_highlight_link_element.text
          contractor_price    = gsa_advantage.contractor_highlight_price
          contractor_page_url = gsa_advantage.contractor_highlight_link_element.href
     else contractor     = 'data not found on product page'
     contractor_price    = '-1'
     contractor_page_url = 'n/a'
     end
else product_page_url = "#{search_url(si, mn)}"
contractor            = 'search returned no results'
contractor_price      = '-1'
contractor_page_url   = 'n/a'
puts "Search #{si} returned no items"
end

begin
     @semaphore.synchronize { @data_out[si] = [mn, contractor, contractor_price, contractor_page_url, product_page_url] }
rescue Exception => e
     puts "MPN:\t#{si}\tMSG:\t#{e.message}"
end

end

@semaphore = Mutex.new
@threads   = []
t_count    = 0;

@search_items.each_index do |index| thr_n = index % N_threads_plus_one
t_count                                   = t_count+1
@threads << Thread.new do search_on_browser(gsa_advantage[thr_n], @search_items[index], @mfr_name[index])
end
if t_count >= N_threads
     @threads.each { |t| t.join if t != Thread.current }
     t_count = 0
end
end

Thread.list.each do |t| t.join if t != Thread.current
end

@data_out.each_pair do |key, value| puts "#{key}\t#{value[0]}\t#{value[1]}\t#{value[2]}\t#{value[3]}\t#{value[4]}"
end

n_row = 0
puts excel_file_out_name
excel_file_out       = Spreadsheet::Workbook.new
gsa_price_sheet      = excel_file_out.create_worksheet
gsa_price_sheet.name = 'GSA Product Price'
gsa_price_sheet.insert_row(n_row, ['mpn', 'manufacturer_name', 'lowest_contractor', 'lowest_contractor_price', 'lowest_contractor_page_url', 'mpn_page_url'])
n_row = n_row + 1

@data_out.each_pair do |key, value| gsa_price_sheet.insert_row(n_row, ["#{key}", "#{value[0]}", "#{value[1]}", "#{value[2]}", "#{value[3]}", "#{value[4]}"])
n_row = n_row + 1
print "#{n_row}\t"
end

excel_file_out.write(excel_file_out_name)


















