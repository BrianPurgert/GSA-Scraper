require_relative '../../adv/gsa_advantage'
require 'roo'

Header    = [/(MFG|MFR|Manufacture)Name/ix, /(MFG|MFR|Manufacture)Number/ix, /(.*)Price(.*)/ix]

Header_MFR     = /(MFG|MFR|Manufacture|Manufacturer) Name/i
Header_PART    = /(MFG|MFR|Manufacture|Manufacturer) Number/i
Header_PRICE   = /(.*)Price(.*)/i


	def import_client_prices(table, set)
		set.collect! do |row|
			[row[:manufacture_name],row[:manufacture_part],row[:gsa_price]]
		end
		  table.import([:manufacture_name, :manufacture_part, :gsa_price], set)
	end


	def self.open_spreadsheet(file)
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
		 spreadsheet.parse(clean: true,   manufacture_name: Header_MFR, manufacture_part:  Header_PART, gsa_price: Header_PRICE)
	end

	def update_priorty(manufacture_name, amount)
	
	end
	

	def import_products(path,table_name)
		spreadsheet = open_spreadsheet(path)
		color_p spreadsheet.info, 12
		table = @DB[table_name]
		set = parse_prices(spreadsheet)
		create_client_table table_name, ['a', 'b', 'c']
		import_client_prices table, set
		# color_p@DB[table_name].all
		# @DB[table_name].each{|row| p row} # SELECT * FROM table
		# [:manufacture_name => 'YJM']
		#     p @DB[table_name][:manufacture_name]
		manufactures = @DB[table_name].order(:id).distinct(:manufacture_name)
		
		# uniq { |mfr| mfr[:manufacture_name] }
		manufactures.each do |manufacture|
			puts manufacture[:manufacture_name]
			@DB[:manufactures]
			# update_priority(manufacture_name, n)
		end
		
		
		
		# manufactures.each { |mfr| p mfr[:href_name] }
		

		# DB[:table].columns
	
		# create_table
		# create_table name, extra_columns
		# parse_prices
	end
