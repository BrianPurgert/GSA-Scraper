require_relative '../../adv/gsa_advantage'
require 'roo'
require 'prettyprint'
require 'pp'

Header_MFR     = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
Header_PART    = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
Header_PRICE   = /(.*)Price(.*)/ix


	def import_client_prices(table, set)
		puts "Importing into #{table}"
		set.each do |row|
			row_manufacture = row[:manufacture_name]
			row_part_number = row[:manufacture_part]
			# color_p"#{row_manufacture} : #{row_part_number}",7

		end
		
		set.collect! do |row|
			[row[:manufacture_name],row[:manufacture_part],row[:gsa_price].to_f.round(2)]
		end
		  table.import([:manufacture_name, :manufacture_part, :gsa_price], set)
	end


	def self.open_spreadsheet(file)
		color_p "\t\tSpreadsheet Open (#{file.inspect}", 8
		spreadsheet = Roo::Spreadsheet.open(file)
		color_p spreadsheet.info, 3
		return spreadsheet
	end

	def create_client_table(name, extra_columns = [])
		 @DB.create_table! name do
			primary_key :id
			String :manufacture_name
			String :manufacture_part
			Float :gsa_price
			 # foreign_key :mpn,:manufacture_parts #mft_data.manufacture_parts.manufacture_parts_mfr_mpn_index
			# String :url
			# String :vendor_name
			# Float  :lowest_price
			# Float  :client_price
		end
	end


	def parse_prices(spreadsheet)
		begin
			puts 'Finding Header Row'
			return spreadsheet.parse(clean: true, manufacture_name: Header_MFR, manufacture_part:  Header_PART, gsa_price: Header_PRICE)
		rescue Exception => e
				puts e.message
		end
		
	end

     def comparison_results
		
     end


def prioritize(table_name)
	distinct_set = @DB[table_name].distinct(:manufacture_name)
	ds = distinct_set.map(:manufacture_name)
	@DB[:manufactures].where(name: ds).update(priority: 109)
	# 	pp @DB[:manufactures].where(name: m).update(priority: 100)#, check_out: 0)
	# 	pp @DB[:manufactures].where(name: x).update(priority: 30)

end

def import_products(path,table_name)
		spreadsheet = open_spreadsheet(path)
		
		table = @DB[table_name]
		set = parse_prices(spreadsheet)
		create_client_table table_name, ['a', 'b', 'c']
		import_client_prices table, set
		prioritize(table_name)
		# table.limit(10).print
	
		# @DB[table_name].each{|row| p row} # SELECT * FROM table
		# [:manufacture_name => 'YJM']
		#     p @DB[table_name][:manufacture_name]
		
		
		# @DB[table_name].order(:id).distinct(:manufacture_name)
		# @DB[table_name].group_and_count(:manufacture_name).all
		
		
	# dataset.each { |mfr| puts mfr.update(:priority=>100,:check_out=>false) }
			# select(:priority).
			# dataset = @DB[:items].select(:x, :y, :z).filter{(x > 1) & (y > 2)}.update(priority: 100)
			# matched_mfr = @DB[:manufactures].where(name: m)
			# puts matched_mfr.all
			
			# DB[:manufactures].update(:x=>nil) # UPDATE table SET x = NULL

			# @DB[:manufactures]
			# update_priority(manufacture_name, n)
		
		
		
		
		# manufactures.each { |mfr| p mfr[:href_name] }
		

		# DB[:table].columns
	
		# create_table
		# create_table name, extra_columns
		# parse_prices
	end
