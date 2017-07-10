# Database file
# Sequel ORM
# Str: jdbc:mysql://gcs-data.mysql.database.azure.com:3306/?user=BrianPurgert@gcs-data
# Str: BrianPurgert@gcs-data0@gcs-data0.mysql.database.azure.com:3306

require 'sequel'
require 'mysql2'
require 'colorize'
require 'colorized_string'
require 'logger'


helpers = Dir.glob(File.join(__dir__, './helpers/')+"*.sql")

begin
	puts "Connecting to #{ENV['MYSQL_HOST']}"
	@DB = Sequel.connect(
		adapter:  "mysql2",
		host:     ENV['MYSQL_HOST'],
		database: 'mft_data',
		user:     ENV['MYSQL_USER'],
		password: ENV['MYSQL_PASS']
	)
rescue Exception => e
	puts "#{e.message}".colorize(:red)
	puts "------------------- Connecting to #{ENV['MYSQL_HOST_ALT']}".colorize(:red)
	@DB = Sequel.connect(
		adapter:  "mysql2",
		host:     ENV['MYSQL_HOST_ALT'],
		database: 'mft_data',
		user:     ENV['MYSQL_USER'],
		password: ENV['MYSQL_PASS']
	)

end



@DB.loggers << Logger.new($stdout) if LOG_DATABASE
@DB.extension :pretty_table
# Sequel.extension :migration

# todo: sequel extension      https://github.com/sdepold/sequel-bit_fields
# todo: sequel extension      https://github.com/earaujoassis/sequel-seed
# todo: sequel extension      http://shrinerb.com/
# ------------------------------------------------------------------ #
#     Create Tables they need to be
# ------------------------------------------------------------------ #
require_relative 'sip/sip_import'
# helpers.each { |sql|  @DB.run File.open(sql, "rb").read }



def clean_copy_parts
	pp @DB.schema(:manufactures).inspect
	pp @DB.schema(:manufacture_parts)
	clean = @DB[:manufacture_parts].order(:last_updated).reverse.distinct(:href_name)
end


# @DB.create_table? :controller do
# 	Integer     :stop
# end
# @DB[:controller].insert(key: 'stop',value: 0)

	@DB.create_table? :searches do
		primary_key :id
		String      :title
		String      :url
		Integer     :found
	end


def create_distinct_manufactures
	@DB.create_table?(:search_manufactures, :as => @DB[:manufactures].distinct(:href_name))
end

create_distinct_manufactures

def create_distinct_products
	# todo: XSB
	@DB.create_table!(:distinct_products,:as => @DB[:manufacture_parts].distinct(:href_name))
end

# do
# 	primary_key(:name, String)
# 	Integer :check_out , :default => '0'
# 	Integer :priority, :default => '0'
# 	String :href_name
# 	# foreign_key :category_id, :categories
#
# 	index :name
# end
# @DB[:manufactures].distinct(:href_name).each do |row|
# 	@DB[:search_manufactures].insert(name: row[:name], href_name: row[:href_name],check_out: '0',priority: '0')
# end

def removing_the_url_from_gsin
	 @DB[:manufacture_parts].run("
	      UPDATE `manufacture_parts`
		SET href_name = REPLACE(href_name, '/advantage/catalog/product_detail.do?gsin=', '')
		WHERE href_name LIKE '/advantage/catalog/product_detail.do?gsin=%';")
end

	def searched(title,url,found)
		items = @DB[:searches]
		items.insert(title: title,url: url,found: found)
	end

	def display_statistics
		manufacture_parts = @DB[:manufacture_parts].distinct(:href_name).count
		manufacture       = @DB[:manufactures]
		color_p "Manufacture Parts count: #{manufacture_parts}", 7
	end

	def priority_manufactures
		result = @DB[:search_manufactures].filter(check_out: 0).order(Sequel.desc(:priority), :name).limit(50)
		result.all
	end

	def take(queue)
		[].tap { |array| i = 0
			until queue.empty? || i == 10000
				array << queue.pop
				i += 1
			end
		}
	end

# ---------------------------------------------------------------------------------#
	def get_mfr(amount = 1)
		if continue
			manufactures = IGNORE_CAT ? @DB[:search_manufactures] : @DB[:manufactures]
			queued_set = manufactures.filter(check_out: 0).order(Sequel.desc(:priority), :name).limit(amount)#.update(priority: 100)
			queued_set.update(check_out: 1)
			up_next = queued_set.all
		else
			up_next = []
		end
		up_next
	end



	def insert_contractors(mfrs)
		@DB[:contractors].import([:name, :href_name, :category, :item_count], mfrs)
	end

	def insert_manufactures(mfrs)
		@DB[:manufactures].import([:name, :href_name, :category, :item_count], mfrs)
	end

	def insert_mfr_parts(mfr_parts_data)
		puts "importing #{mfr_parts_data.size} items"
		@DB[:manufacture_parts].import([:mfr, :mpn, :name, :href_name, :desc, :low_price, :sources], mfr_parts_data, opts={commit_every: 2000})
	end

	def check_in(mfr,cat)
		@DB[:manufactures].where(name: mfr, category: cat).update(check_out: 2)
		# safe_stop
	end

	def continue_exec
		@continue = true
	end

	def continue
		stop = @DB[:controller].filter(key: 'stop').select(:value).first
		print 'Controller: '
		if stop[:value]==1
			puts "Stopping".colorize(:red)
			@continue = false
		else
			puts "Continue".colorize(:green)
			@continue = true
		end
		
	end
	
	# def mfr_time(name)
	# 	escaped       = @client.escape("#{name}")
	# 	insert_string = "UPDATE mft_data.manufactures SET last_search=NOW() WHERE name='#{escaped}'"
	# 	puts insert_string.colorize(:green)
	# 	@client.query("#{insert_string}")
	# end

	# def get_mfr_part(amount = 1)
	# 	row_list = []
	#
	# 	result = @client.query("SELECT * FROM `mft_data`.`mfr_parts` ORDER BY last_updated LIMIT #{amount};", :symbolize_keys => true)
	# 	result.each do |row|
	# 		row_list << row
	# 	end
	# 	mfr_part_href = row_list.map!{|link| link[:href_name]}
	# 	check_out_parts(amount)
	# 	return mfr_part_href
	# end







