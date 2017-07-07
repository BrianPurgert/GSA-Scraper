require_relative '../adv/gsa_advantage'
require 'roo'
require 'prettyprint'
require 'pp'

Header_MFR   = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
Header_PART  = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
Header_PRICE = /(.*)GSAPrice(.*)/ix


def file_to_table_name(file)
	filename   = File.basename(file)
	table_name = "pcp_#{filename.gsub!(' ', '_').split('.').first.downcase!}"
	color_p "Spread sheet Open #{filename}", 8
	table_name
end




def parse_prices(spreadsheet)
	# puts 'first row'
	# puts spreadsheet.row(1)
	# puts spreadsheet.column(1)

	print 'Finding Header Row '
	begin
		spreadsheet.parse(clean: true, manufacture_name: Header_MFR, manufacture_part: Header_PART, gsa_price: Header_PRICE)
	rescue Exception => e
		puts e.message
	end

end

def import_client_prices(table, set)
	puts "Importing into #{table}"
	
	set.collect! do |row|
		[row[:manufacture_name].to_s.upcase,
		 row[:manufacture_part].to_s.upcase,
		 row[:gsa_price].to_f.round(2)]
	end
	@DB[table].import([:manufacture_name, :manufacture_part, :gsa_price], set)
	# TODO prioritize(table)
end

def import_products(path)
	begin
		spreadsheet = Roo::Spreadsheet.open(path)
		color_p spreadsheet.info, 3
		table_name      = file_to_table_name(path)
		product_dataset = parse_prices(spreadsheet)
		puts "DB Table name will be: #{table_name}"
		
		
		# Alternative could be to import their spreadsheet directly
		# @DB.create_table?(:search_manufactures, :as => @DB[:manufactures].distinct(:href_name))
		@DB.create_table!(table_name) do
			primary_key :id
			String :manufacture_name
			String :manufacture_part
			String :product_name
			Float :gsa_price
		end
		
		
		# column :title, :text
		#     index :title
		# String :url
		# String :vendor_name
		# Float  :lowest_price
		# Float  :client_price
		# gsa_price
		# String :contract_number
		# String :manufacture_part
		# String :manufacture_name
		# String :product_name
		# String :vendor_part
		# String :produdct_desc
		# String :proddesc2
		# String :proddesc3
		# String :proddesc4
		# String :nsn
		
		
		import_client_prices(table_name, product_dataset)

#   DB.add_index :posts, :title
#   DB.add_index :posts, [:author, :title], :unique => true
#
# rename_table_sql(name, new_name)
# Options:
# :ignore_errors :: Ignore any DatabaseErrors that are raised
# :name :: Name to use for index instead of default


#   DB.add_column :items, :name, :text, :unique => true, :null => false
#   DB.add_column :items, :category, :text, :default => 'ruby'
# create_join_table(:cat_id=>{:table=>:cats, :type=>:Bignum}, :dog_id=>:dogs)
# create_join_table(:cat_id=>:cats, :dog_id=>:dogs)
# DB.drop_column :items, :category

# rescue Exception => e
# 	puts e.message
	end
end


def find_duplicates
	@DB[:manufacture_parts].order(:last_updated).distinct(:mfr, :mpn)
	@DB[:search_manufactures].group_and_count(:mfr, :mpn)
end

def prioritize(table)
	manufacture_count = table.group_and_count(:manufacture_name)
	manufacture_count.each do |mfr|
		
		manufacture = mfr[:manufacture_name]
		priority    = mfr[:count]+10
		
		affected = @DB[:search_manufactures].where(name: manufacture).update(priority: priority, check_out: 0)
		if affected>0
			puts "#{mfr[:manufacture_name]} : #{affected}".colorize(:green)
		else
			puts "No Similar Manufacture Names found\n#{mfr[:manufacture_name]} : #{affected}".colorize(:red)
			# highlight columns or prompt
			similar  = mfr[:manufacture_name].gsub!(/[^0-9A-Za-z]/, '%') #
			affected = @DB[:search_manufactures].where(Sequel.ilike(:name, similar)).update(priority: priority, check_out: 0)
			puts "#{similar} #{affected}"
		end
	end
end

