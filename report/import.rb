require 'roo'
require 'prettyprint'
require 'pp'
require 'roo-xls'
require 'colorize'
require 'prettyprint'

Header_MFR     = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
Header_PART    = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
Header_PRICE   = /(.*)Price(.*)/ix

Header_GENERAL     = /(MFG|MFR|Manufacture|Manufacturer|SIN|PRODUCT|UOI|PRICE|DISCOUNT|QUANTITY|Contract|CONTNUM|MFGPART|MFGNAME|BPAPRICE|SCHEDCAT)/ix

# MFR PART NO
# {"SIN"=>"Avatier Group Enforcer Licensing",
#  "MANUFACTURER NAME"=>nil,
#  "MFR PART NO"=>nil,
#  "PRODUCT NAME AND DESCRIPTION"=>nil,
#  "UOI"=>nil,
#  "COMMERCIAL LIST PRICE"=>nil,
#  "MOST FAVORED CUSTOMER (MFC)"=>nil,
#  "MFC PRICE"=>nil,
#  "MFC (%) DISCOUNT"=>nil,
#  "GSA OFFER PRICE (exclusive of the .75% IFF)"=>nil,
#  "GSA(%) DISCOUNT (exclusive of the .75% IFF)"=>nil,
#  "GSA OFFER PRICE (inclusive of the .75% IFF)"=>nil,
#  "QUANTITY/VOLUME DISCOUNT"=>nil,
#  "COO"=>nil},




	def create_client_table(name, extra_columns = [])
		color_p "#{name.class}  #{name.to_s}   #{name.inspect}   #{name}"
		  DB.create_table! name do
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
	DB[:manufacture_parts].order(:last_updated).distinct(:mfr, :mpn)
	DB[:search_manufactures].group_and_count(:mfr, :mpn)
end

def prioritize(table)
	manufacture_count = table.group_and_count(:manufacture_name)
	manufacture_count.each do |mfr|
		similar = mfr[:manufacture_name]
		priority = mfr[:count]+10
		affected = DB[:search_manufactures].where(:name, similar).update(priority: priority, check_out: 0)
		
		if affected>0
			puts "#{mfr[:manufacture_name]} : #{affected}".colorize(:green)
		else
			puts "No Similar Manufacture Names found\n#{mfr[:manufacture_name]} : #{affected}".colorize(:red)
			similar = mfr[:manufacture_name].gsub!(/[^0-9A-Za-z]/, '%')
			affected = DB[:search_manufactures].where(Sequel.ilike(:name, similar)).update(priority: priority, check_out: 0)
			puts "#{similar} #{affected}"
		end
	end
end

def import_products(path)
	
		" | Parsing from: #{Pathname.new(path).basename}"
		# begin
		# 	xl_sheet = puts RubyXL::Parser.parse(path)
		# 	puts xl_sheet.pretty_inspect.colorize(:white)
		# rescue
		# 	puts 'opps'
		# end


		begin
			
			sheet = Roo::Spreadsheet.open(path)
			sheet_data = Roo::Spreadsheet.open(path).parse(clean: true, header_search: [Header_GENERAL])
			color_p sheet_data.pretty_inspect
		rescue
			puts 'No Header Row Found'
		end
	
	
		# DB[table].multi_insert(sheet_data)
		
		
		# columns = DB[table].columns.to_a
		# DB[table].import(columns, sheet_data)

	
		

	

end


#   DB.add_index :posts, :title
#   DB.add_index :posts, [:author, :title], :unique => true
# Options:
# :ignore_errors :: Ignore any DatabaseErrors that are raised
# :name :: Name to use for index instead of default

#   DB.add_column :items, :name, :text, :unique => true, :null => false
#   DB.add_column :items, :category, :text, :default => 'ruby'
#    DB.drop_column :items, :category