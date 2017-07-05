require_relative '../adv/gsa_advantage'
require 'roo'
require 'prettyprint'
require 'pp'

Header_MFR   = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
Header_PART  = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
Header_PRICE = /(.*)GSAPrice(.*)/ix


def import_client_prices(table, set)
	puts "Importing into #{table}"
	set.each do |row|
		row_manufacture = row[:manufacture_name]
		row_part_number = row[:manufacture_part]
		# color_p"#{row_manufacture} : #{row_part_number}",7
	end
	
	set.collect! do |row|
		[row[:manufacture_name].to_s, row[:manufacture_part].to_s, row[:gsa_price].to_f.round(2)]
	end
	table.import([:manufacture_name, :manufacture_part, :gsa_price], set)
	prioritize(table)
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
	print 'Finding Header Row '
	begin
		return spreadsheet.parse(clean: true, manufacture_name: Header_MFR, manufacture_part: Header_PART, gsa_price: Header_PRICE)
		puts 'found'
	rescue Exception => e
		puts e.message
	end

end

def comparison_results

end


def find_duplicates
	@DB[:manufacture_parts].order(:last_updated).distinct(:mfr, :mpn)
	@DB[:search_manufactures].group_and_count(:mfr, :mpn)
end

def prioritize(table)
	manufacture_count = table.group_and_count(:manufacture_name)
	manufacture_count.each do |mfr|
		similar  = "%#{mfr[:manufacture_name]}%"
		priority = mfr[:count]+10
		affected = @DB[:search_manufactures].where(Sequel.ilike(:name, similar)).update(priority: priority, check_out: 0)
		
		if affected>0
			puts "#{mfr[:manufacture_name]} : #{affected}".colorize(:green)
		else
			puts "No Similar Manufacture Names found\n#{mfr[:manufacture_name]} : #{affected}".colorize(:red)
			similar  = mfr[:manufacture_name].gsub!(/[^0-9A-Za-z]/, '%')
			affected = @DB[:search_manufactures].where(Sequel.ilike(:name, similar)).update(priority: priority, check_out: 0)
			puts "#{similar} #{affected}"
		end
	end
end

def import_products(path, table_name)
	
	begin
		spreadsheet = open_spreadsheet(path)
		table       = @DB[table_name]
		set         = parse_prices(spreadsheet)
		create_client_table table_name, ['a', 'b', 'c']
		import_client_prices table, set
	rescue Exception => e
		puts e.message
	end


end
