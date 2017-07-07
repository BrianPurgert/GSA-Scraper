require_relative File.dirname(__FILE__) + '/./import'
require_relative File.dirname(__FILE__) + '/./export'


# Dir["*.rb"].each { |file| require_relative(file) }
basedir   = File.join(__dir__, 'test/')
files     = Dir.glob(basedir+"*.xlsx")
csv_files = Dir.glob(basedir+"*.csv")
xls_files = Dir.glob(basedir+"*.xls")
puts Dir.entries(basedir).inspect
# todo name tables
@tables = []


tables  = [:client1, :client2, :client3, :client4, :client5, :client6, :client7, :client8, :client9]


def list_files(files)
	files.each_with_index do |file, num|
		puts "#{num}\t#{file}".colorize(:green)
		#    %s() # turns foo into a symbol (:foo)
	end
end

def import_spreadsheets(files, tables)
	puts "Import Spreadsheets? (Y/N)".colorize(:green)
	if gets.to_s.upcase.include? 'Y'
		puts "#{files.size} files importing"
		threads = []
		files.each_with_index do |file, num|
			threads << Thread.new { import_products file }
		end
		threads.each { |thr| thr.join }
	end
end

def export_price_comparisons(files, tables)
	puts "Generate Price Comparisons? (Y/N)".colorize(:green)
	if gets.to_s.upcase.include? 'Y'
		threads = []
		files.each_with_index do |file, num|
			threads << Thread.new { excel tables[num] }
		end
		threads.each { |thr| thr.join }
	end
end

list_files(files)
import_spreadsheets(files, tables)
export_price_comparisons(files, tables)
