require 'roo'
require 'roo-xls'
# require 'simple_xlsx_reader'
require 'rubyXL'
require 'pathname'
 # require 'creek'
# require 'spreadsheet'
# require 'fastercsv'
# require 'axlsx'

class AnySheet
	def initialize (path)
		 puts Pathname.new(path).extname
		# begin
		# 	workbook = RubyXL::Parser.parse path
		# 	worksheets = workbook.worksheets
		# 	puts "Found #{worksheets.count} worksheets"
		# 	worksheets.each do |worksheet|
		# 		puts "Reading: #{worksheet.sheet_name}"
		# 		num_rows = 0
		# 		worksheet.each do |row|
		# 			row_cells = row.cells.map{ |cell| cell.value }
		# 			num_rows += 1
		# 			# uncomment to print out row values
		# 			# puts row_cells.join " "
		# 		end
		# 		puts "Read #{num_rows} rows"
		# 	end
		#
		# 	puts 'Done'
		# rescue
		# end
		#  case File.extname(file.original_filename)
		
		 case Pathname.new(path).extname
			 when '.csv' then  Roo::CSV.new(path,ignore: nil)
			 when '.xls' then   Roo::Spreadsheet.open(path, extension: :xls) # Roo::Excel.new(path, ignore: nil )
			 when '.xlsx' then
				     begin
				          RubyXL::Parser.parse(path)
				     rescue
				          Roo::Excelx.new(path, ignore:nil)
			          end
								
			 
		 end
	end
	


	


end

# csv = Roo::CSV.new("mycsv.csv")
# spreadsheet = Roo::Spreadsheet.open(file)
# workbook = RubyXL::Parser.parse("path/to/Excel/file.xlsx")