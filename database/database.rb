

# Database file
# Sequel ORM
# Str: jdbc:mysql://gcs-data.mysql.database.azure.com:3306/?user=BrianPurgert@gcs-data
# Str: BrianPurgert@gcs-data0@gcs-data0.mysql.database.azure.com:3306
module ADV

require 'sequel'
require 'mysql2'
require 'colorize'
require 'colorized_string'
require 'logger'

DB = begin
    puts "------- Connecting to Connecting to #{ENV['MYSQL_HOST']}".colorize(:red)
    Sequel.connect(
        adapter: "mysql2",
        host:     ENV['MYSQL_HOST'],
        database: ENV['MYSQL_DATABASE'],
        user:     ENV['MYSQL_USER'],
        password: ENV['MYSQL_PASS']
    )
  rescue Exception => e
    puts "#{e.message}".colorize(:red)
    puts "------- Connecting to #{ENV['MYSQL_HOST_ALT']}".colorize(:red)
    Sequel.connect(
        adapter: "mysql2",
        host: ENV['MYSQL_HOST_ALT'],
        database: ENV['MYSQL_DATABASE'],
        user: ENV['MYSQL_USER'],
        password: ENV['MYSQL_PASS']
    )
  end
DB




DB.loggers << Logger.new($stdout) if ADV::LOG_DATABASE
DB.extension :pretty_table

# ------------------------------------------------------------------ #
#     Create Tables
# ------------------------------------------------------------------ #
 require_relative 'sip/sip_import'
helpers = Dir.glob(File.join(__dir__, './helpers/')+"*.sql")
helpers.each { |sql|  DB.run File.open(sql, "rb").read }

DB.create_table? :searches do
  primary_key :id
  String      :title
  String      :url
  Integer     :found
end

def clean_copy_parts
	pp DB.schema(:manufactures).inspect
	pp DB.schema(:manufacture_parts)
	clean = DB[:manufacture_parts].order(:last_updated).reverse.distinct(:href_name)
end

def create_search_tables(db)
	db.create_table?(:search_manufactures, :as => db[:manufactures].distinct(:href_name))
	db.create_table?(:search_manufactures, :as => db[:manufactures].distinct(:href_name))
end

def create_distinct_products
	DB.create_table!(:distinct_products, :as => DB[:manufacture_parts].distinct(:href_name))
end


def href_to_gsin
      DB[:manufacture_parts].run("
        UPDATE `manufacture_parts`
        SET href_name = REPLACE(href_name, '/advantage/catalog/product_detail.do?gsin=', '')
        WHERE href_name LIKE '/advantage/catalog/product_detail.do?gsin=%';
      ")
end

def searched(title,url,found)
	items = DB[:searches]
	items.insert(title: title,url: url,found: found)
end

def display_statistics
	manufacture_parts = DB[:manufacture_parts].distinct(:href_name).count
	manufacture       = DB[:manufactures]
	puts "Manufacture Parts count: #{manufacture_parts}"
end

def priority_manufactures
	result = DB[:search_manufactures].filter(check_out: 0).order(Sequel.desc(:priority), :name).limit(100)
	result.all
end

def take(queue)
  [].tap { |array| i = 0
    until queue.empty? || i == 5000
			array << queue.pop
				i += 1
			end
		}
	end

# ---------------------------------------------------------------------------------#

def get_search(amount = 1)
      puts "manufacture_search_index: #{@manufacture_search_index}"
      queued_set = DB[:manufacture_search].limit(amount, @manufacture_search_index)
      @manufacture_search_index = amount + @manufacture_search_index
			queued_set.print
      queued_set.map { |value| value[:href_name]}
      # queued_set
	end




	def insert_mfr_parts(mfr_parts_data)
		puts "importing #{mfr_parts_data.size} items"
		DB[:manufacture_parts].import([:mfr, :mpn, :name, :href_name, :desc, :low_price, :sources], mfr_parts_data)#opts={commit_every: 1000}
	end

	def check_in(mfr,cat)
		DB[:manufactures].where(name: mfr, category: cat).update(check_out: 2)
		# safe_stop
	end

	def continue_exec
		@continue = true
	end

  def continue
    begin
      stop = DB[:controller].filter(key: 'stop').select(:value).first
      print 'Controller: '
      if stop[:value]==1
        puts "Stopping".colorize(:red)
        @continue = false
      else
        puts "Continue".colorize(:green)
        @continue = true
      end
    rescue
      DB.create_table? :controller do
        primary_key :id
        String :key
        String :value
      end

      DB[:controller].insert(key: 'stop', value: 0)
    end
  end
end


def import_thread
  Thread.new do
    until @release
      sleep 1
      unless @queue[:category].empty?
        DB[:categories].import([:department, :category, :id], take(@queue[:category]))
      end

      unless @queue[:manufactures].empty?
        DB[:manufactures].import([:name, :href_name, :category, :item_count], take(@queue[:manufactures]))
      end

      unless @queue[:contractors].empty?
        DB[:contractors].import([:name, :href_name, :category, :item_count], take(@queue[:contractors]))
      end

    end
  end
end



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







