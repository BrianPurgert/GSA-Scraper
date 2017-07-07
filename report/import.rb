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
		[row[:manufacture_name].to_s.upcase, row[:manufacture_part].to_s.upcase, row[:gsa_price].to_f.round(2)]
	end
	table.import([:manufacture_name, :manufacture_part, :gsa_price], set)
	prioritize(table)
end


def self.open_spreadsheet(file)
	filename          = File.basename(file)
	table             = "pcp_#{filename.gsub!(' ','_').split('.').first.downcase!}"
	color_p           "Spread sheet Open (#{filename}", 8
	spreadsheet       = Roo::Spreadsheet.open(file)
	color_p           spreadsheet.info, 3
	puts table
	return {spreadsheet: spreadsheet, table_name: table}
end




def parse_prices(spreadsheet)
	puts 'first row'
	pp row(0)
	pp column(1)
	sleep 10
	exit
	
	@DB.create_table?(:search_manufactures, :as => @DB[:manufactures].distinct(:href_name))
	
	print 'Finding Header Row '
	begin
		spreadsheet.parse(clean: true, manufacture_name: Header_MFR, manufacture_part: Header_PART, gsa_price: Header_PRICE)
	rescue Exception => e
		puts e.message
	end

end



def gsa_basic_table(import)
	ss          = import[:spreadsheet]
	table       = import[:table].to_s
	
		@DB.create_table!(table)
		
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
		
		String :contract
		String :manufacture_name
		String :manufacture_part
		String :product_name
		Float  :gsa_price
		# String :url
		# String :vendor_name
		# Float  :lowest_price
		# Float  :client_price
	
	
    #   DB.add_index :posts, :title
    #   DB.add_index :posts, [:author, :title], :unique => true
    #
	rename_table_sql(name, new_name)
	
    # Options:
    # :ignore_errors :: Ignore any DatabaseErrors that are raised
    # :name :: Name to use for index instead of default
	
	    # Adds a column to the specified table. This method expects a column name,
    # a datatype and optionally a hash with additional constraints and options:
    #
    #   DB.add_column :items, :name, :text, :unique => true, :null => false
    #   DB.add_column :items, :category, :text, :default => 'ruby'
	
	create_join_table(:cat_id=>{:table=>:cats, :type=>:Bignum}, :dog_id=>:dogs)
	
      create_join_table(:cat_id=>:cats, :dog_id=>:dogs)
      # CREATE TABLE cats_dogs (
      #  cat_id integer NOT NULL REFERENCES cats,
      #  dog_id integer NOT NULL REFERENCES dogs,
      #  PRIMARY KEY (cat_id, dog_id)
      # )
      # CREATE INDEX cats_dogs_dog_id_cat_id_index ON cats_dogs(dog_id, cat_id)
	

	
	# DB.drop_column :items, :category
end


def import_products(path)
	begin
		import = open_spreadsheet(path)
		build_table(import)
		import_client_prices table, set
	# rescue Exception => e
	# 	puts e.message
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
		
		manufacture  = mfr[:manufacture_name]
		priority = mfr[:count]+10
		
		affected = @DB[:search_manufactures].where(name: manufacture).update(priority: priority, check_out: 0)
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

