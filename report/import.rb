require_relative File.expand_path(File.dirname(__FILE__) + '/../adv/gsa_advantage')
require 'roo'
require 'prettyprint'
require 'pp'
require 'roo-xls'

Header_MFR     = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
Header_PART    = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
Header_PRICE   = /(.*)Price(.*)/ix






	def create_client_table(name, extra_columns = [])
		color_p "#{name.class}  #{name.to_s}   #{name.inspect}   #{name}"
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

def import_products(path)
	
	if path.upcase.include? "IPROD"
		color_p "IPROD | Import products from: #{Pathname.new(path).basename}"
		sheet_data = Roo::Spreadsheet.open(path).parse(clean: true, header_search: [Header_MFR,Header_PART])  #  RubyXL::Parser.parse("path/to/Excel/file.xlsx")
		@DB[:IPROD].multi_insert(sheet_data)
		
		
		# columns = @DB[:IPROD].columns.to_a # @DB[:IPROD].import(@DB[:IPROD].columns!, sheet_data)
		# color_p "#{sheet_data.class}   #{sheet_data[0].class}\nReference Columns\n#{columns}", 13
		# sheet_data.collect! do |import_column|
		# 	columns.collect do |database_column|
		# 		import_column[database_column]
		# 	end
		# 	# [import_column[:manufacture_name].to_s, import_column[:manufacture_part].to_s, import_column[:gsa_price].to_f.round(2)]
		# end
		
	end
	
	# table = @DB[table_name]
	
	# create_client_table table_name,['a', 'b', 'c']
	# import_client_prices table, set
		# rescue Exception => e
		# 	puts e.message
		# end
end


#   DB.add_index :posts, :title
#   DB.add_index :posts, [:author, :title], :unique => true
# Options:
# :ignore_errors :: Ignore any DatabaseErrors that are raised
# :name :: Name to use for index instead of default

#   DB.add_column :items, :name, :text, :unique => true, :null => false
#   DB.add_column :items, :category, :text, :default => 'ruby'
#    DB.drop_column :items, :category