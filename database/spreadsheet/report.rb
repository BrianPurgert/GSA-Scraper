require_relative './import'
require_relative './export'
# Dir["*.rb"].each { |file| require_relative(file) }
basedir                     = File.join(__dir__,'test/')
files                       = Dir.glob(basedir+"*.xlsx")
csv_files                   = Dir.glob(basedir+"*.csv")
xls_files                   = Dir.glob(basedir+"*.xls")
# todo name tables
@tables = []
tables = [:client1,:client2,:client3,:client4,:client5,:client6,:client7,:client8,:client9]


def list_files(files)
	files.each_with_index do |file, num|
		puts "#{num}\t#{file}".colorize(:green)
	end
end

def import_spreadsheets(files, tables)
	puts "Import Spreadsheets? (Y/N)".colorize(:green)
	if gets.to_s.upcase.include? 'Y'
		files.each_with_index do |file, num|
			import_products file, tables[num]
		end
	end
end

def export_price_comparisons(files, tables)
	puts "Generate Price Comparisons? (Y/N)".colorize(:green)
	if gets.to_s.upcase.include? 'Y'
		files.each_with_index do |file, num|
			excel tables[num]
		end
	end
end

list_files(files)

import_spreadsheets(files, tables)
export_price_comparisons(files, tables)
