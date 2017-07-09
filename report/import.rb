require_relative '../adv/gsa_advantage'
require 'roo'
require 'prettyprint'
require 'pp'
require 'roo-xls'

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
			
			@DB.create_table!(:IACCXPRO) do       # common database type used
				Integer :a0                         # integer
				String :a1                          # varchar(255)
				String :a2, :size=>50               # varchar(50)
				String :a3, :fixed=>true            # char(255)
				String :a4, :fixed=>true, :size=>50 # char(50)
				String :a5, :text=>true             # text
				File :b                             # blob
				Fixnum :c                           # integer
				Bignum :d                           # bigint
				Float :e                            # double precision
				BigDecimal :f                       # numeric
				BigDecimal :f2, :size=>10           # numeric(10)
				BigDecimal :f3, :size=>[10, 2]      # numeric(10, 2)
				Date :g                             # date
				DateTime :h                         # timestamp
				Time :i                             # timestamp
				Time :i2, :only_time=>true          # time
				Numeric :j                          # numeric
				TrueClass :k                        # boolean
				FalseClass :l                       # boolean
			end
			 
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
			return spreadsheet.parse(clean: true, manufacture_name: Header_MFR, manufacture_part:  Header_PART, gsa_price: Header_PRICE)
			puts 'found'
		rescue Exception => e
				puts e.message
		end
		
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

		begin
			spreadsheet = open_spreadsheet(path)
			table = @DB[table_name]
			set = parse_prices(spreadsheet)
			create_client_table table_name, ['a', 'b', 'c']
			import_client_prices table, set
		rescue Exception => e
			puts e.message
		end
		
		
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