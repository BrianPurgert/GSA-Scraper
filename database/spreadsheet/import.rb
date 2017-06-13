require_relative '../../adv/gsa_advantage'
require 'roo'


	def import_client_prices(table, set)
		p set.size
		set.each do |col|
			p col.inspect
			p col.class
		end
		# table.import([:manufacture_name, :manufacture_part, :client_price], set)
	end

	# xlsx = Roo::Spreadsheet.open(path)
	def self.open_spreadsheet(file)
		Roo::Spreadsheet.open(file)
		# case File.extname(file.original_filename)
		# 	when ".csv"       then Roo::CSV.new(file.path, nil, :ignore)
		# 	when ".xls"       then Roo::Excel.new(file.path, nil, :ignore)
		# 	when ".xlsx"      then Roo::Excelx.new(file.path, nil, :ignore)
		# 	else raise "Unknown file type: #{file.original_filename}"
		# end
	end


	def comparison_table(name, extra_columns = [])
		@DB.create_table! name do
			primary_key :id
			String :manufacture_name            #'MFG Name'
			String :manufacture_part            #'Mfg Part number'
			String :gsa_price
			String :url                         #'URL'
			String :vendor_name                 #'Vendor Name'
			Float  :lowest_price                # Lowest Price
			Float  :client_price                # 'Client Price' # (From input table)
		end
	end

	def parse_prices(spreadsheet)
		 set = spreadsheet.parse(clean: true,
		 			manufacture_name: /(MFG|MFR|Manufacture) Name/i,
		 			manufacture_part: /(MFG|MFR|Manufacture) Number/i,
		 			client_price:        /(.*)Price(.*)/i)
		
		set.map!(array)
		
		# set = spreadsheet.parse(clean: true, /(MFG|MFR|Manufacture) Name/i, /(MFG|MFR|Manufacture) Number/i, /(.*)Price(.*)/i)
		
		return set
	end

	def import_products(path)
		table_name = :pcp_123
		spreadsheet = open_spreadsheet(path)
		set = parse_prices(spreadsheet)
		comparison_table table_name, ['a','b','c']
		import_client_prices @DB[table_name], set
		
		
		# dataset = DB.from(:items)
		# create_table
		# create_table name, extra_columns
		# parse_prices
	end
