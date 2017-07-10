require_relative File.expand_path(File.dirname(__FILE__) + '/../adv/gsa_advantage')
require 'roo'
require 'prettyprint'
require 'pp'
require 'roo-xls'
require_relative File.expand_path(File.dirname(__FILE__) + '/any_sheet')

Header_MFR     = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
Header_PART    = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
Header_PRICE   = /(.*)Price(.*)/ix


	def import_client_prices(table, set)
		puts "Importing into #{table}"
		set.each do |row|
			row_manufacture = row[:manufacture_name]
			row_part_number = row[:manufacture_part]
			 color_p"#{row_manufacture} : #{row_part_number}",7
		end
		
		if set[0].size      == 2
			[row[:manufacture_name].to_s,row[:manufacture_part].to_s]
		elsif set[0].size   == 3
			[row[:manufacture_name].to_s,row[:manufacture_part].to_s,row[:gsa_price].to_f.round(2)]
		end
		
		set.collect! do |row|
		
		end
		  table.import([:manufacture_name, :manufacture_part, :gsa_price], set)
		prioritize(table)
	end


	def open_spreadsheet(file_path)
		color_p "\t\tSpreadsheet Open (#{file_path}", 8
		spreadsheet = AnySheet.new(file_path)
		
	
		puts "#{spreadsheet.info}".colorize(:green)
		return spreadsheet
	end

	def create_client_table(name, extra_columns = [])
		 @DB.create_table! name do
			primary_key :id
			String :manufacture_name, null: true
			String :manufacture_part, null: true
			Float :gsa_price         ,null: true
			
		
			# foreign_key :mpn,:manufacture_parts #mft_data.manufacture_parts.manufacture_parts_mfr_mpn_index
			String :url, null: true
			 String :vendor_name, null: true
			 Float  :lowest_price, null: true
			 Float  :client_price, null: true
		end
	end


	def parse_prices(spreadsheet)
		# first_row = spreadsheet.first_row
		spreadsheet.each { |sheet| puts sheet.inspect }
		
			
			# return spreadsheet.parse(clean: true, header_search: [Header_MFR,Header_PART])
			sleep 40
		# rescue Exception => e
		# 		puts e.message
		# end
		
	end

     def comparison_results
		
     end


def find_duplicates
	@DB[:manufacture_parts].order(:last_updated).distinct(:mfr,:mpn)
	@DB[:search_manufactures].group_and_count(:mfr,:mpn)
end

def prioritize(table)
	manufacture_count = table.group_and_count(:manufacture_name)
	manufacture_count.each do |mfr|
		similar = mfr[:manufacture_name]
		priority = mfr[:count]+10
		affected = @DB[:search_manufactures].where(:name, similar).update(priority: priority, check_out: 0)
		
		if affected>0
			puts "#{mfr[:manufacture_name]} : #{affected}".colorize(:green)
		else
			puts "No Similar Manufacture Names found\n#{mfr[:manufacture_name]} : #{affected}".colorize(:red)
			similar = mfr[:manufacture_name].gsub!(/[^0-9A-Za-z]/, '%')
			affected = @DB[:search_manufactures].where(Sequel.ilike(:name, similar)).update(priority: priority, check_out: 0)
			puts "#{similar} #{affected}"
		end
	end
end

def import_products(path,table_name)
		# begin
			spreadsheet = open_spreadsheet(path)
			table = @DB[table_name]
			set = parse_prices(spreadsheet)
			create_client_table table_name, ['a', 'b', 'c']
			import_client_prices table, set
		# rescue Exception => e
		# 	puts e.message
		# end
		
		
	end



#   DB.add_index :posts, :title
#   DB.add_index :posts, [:author, :title], :unique => true
#
# rename_table_sql(name, new_name)
# Options:
# :ignore_errors :: Ignore any DatabaseErrors that are raised
# :name :: Name to use for index instead of default


#   DB.add_column :items, :name, :text, :unique => true, :null => false
#   DB.add_column :items, :category, :text, :default => 'ruby'
#    DB.drop_column :items, :category