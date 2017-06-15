require_relative '../../adv/gsa_advantage'
require 'roo'
require 'prettyprint'
require 'pp'

Header    = [/(MFG|MFR|Manufacture)Name/ix, /(MFG|MFR|Manufacture)Number/ix, /(.*)Price(.*)/ix]

Header_MFR     = /(MFG|MFR|Manufacture|Manufacturer) Name/i
Header_PART    = /(MFG|MFR|Manufacture|Manufacturer) Number/i
Header_PRICE   = /(.*)Price(.*)/i


	def import_client_prices(table, set)
	spreadsheet_table = @DB[:test1]
	
		#temporary solution
		set.each do |row|
			row_manufacture = row[:manufacture_name]
			row_part_number = row[:manufacture_part]
			bp ["----","#{row_manufacture}","","#{row_part_number}","-----"], [1,25,1,25,1]
			part         = @DB[:manufacture_parts][:mpn => row_part_number]
			#[:mfr => row_manufacture]
			color_p part.inspect
		end
		
		set.collect! do |row|
			[row[:manufacture_name],row[:manufacture_part],row[:gsa_price]]
		end
		  table.import([:manufacture_name, :manufacture_part, :gsa_price], set)
	end


	def self.open_spreadsheet(file)
		color_p "\t\tSpreadsheet Open (#{file.inspect}", 8
			Roo::Spreadsheet.open(file)
		# case File.extname(file.original_filename)
		# 	when ".csv"       then Roo::CSV.new(file.path, nil, :ignore)
		# 	when ".xls"       then Roo::Excel.new(file.path, nil, :ignore)
		# 	when ".xlsx"      then Roo::Excelx.new(file.path, nil, :ignore)
		# 	else raise "Unknown file type: #{file.original_filename}"
		# end
		
	end

	def create_client_table(name, extra_columns = [])
		@DB.create_table! name do
			primary_key :id
			String :manufacture_name
			String :manufacture_part
			Float :gsa_price
			# String :url
			# String :vendor_name
			# Float  :lowest_price
			# Float  :client_price
		end
	end


	def parse_prices(spreadsheet)
		begin
			return spreadsheet.parse(clean: true, manufacture_name: Header_MFR, manufacture_part:  Header_PART, gsa_price: Header_PRICE)
		rescue Exception => e
				puts e.message
			# TODO: return a template file
		end
		
	end

     def comparison_results
		
     end
	
	def update_priority(manufacture_name, amount)
		@DB[:manufactures][]
	end
	

	def import_products(path,table_name)
		spreadsheet = open_spreadsheet(path)
		color_p spreadsheet.info, 3
		table = @DB[table_name]
		table.print
		set = parse_prices(spreadsheet)
		create_client_table table_name, ['a', 'b', 'c']
		import_client_prices table, set
		# color_p@DB[table_name].all
		# @DB[table_name].each{|row| p row} # SELECT * FROM table
		# [:manufacture_name => 'YJM']
		#     p @DB[table_name][:manufacture_name]
		
		# uniq { |mfr| mfr[:manufacture_name] }
		# @DB[table_name].order(:id).distinct(:manufacture_name)
		# @DB[table_name].group_and_count(:manufacture_name).all
		
		@DB[table_name].order(:id).distinct(:manufacture_name).each do |manufacture|
			m = manufacture[:manufacture_name]
			color_p "adding #{m}"
			
			
			dataset = @DB[:manufactures] #.filter(name: m)#.update(priority: 100)
			dataset.where(name:  m).update(priority: 110)
			
			
			# dataset.each { |mfr| puts mfr.update(:priority=>100,:check_out=>false) }
			# select(:priority).
			# dataset = @DB[:items].select(:x, :y, :z).filter{(x > 1) & (y > 2)}.update(priority: 100)
			# matched_mfr = @DB[:manufactures].where(name: m)
			# puts matched_mfr.all
			
			# DB[:manufactures].update(:x=>nil) # UPDATE table SET x = NULL

			# @DB[:manufactures]
			# update_priority(manufacture_name, n)
		end
		
		
		
		# manufactures.each { |mfr| p mfr[:href_name] }
		

		# DB[:table].columns
	
		# create_table
		# create_table name, extra_columns
		# parse_prices
	end
