# Database file
# Sequel ORM
# Why? https://twin.github.io/evaluating-ruby-libraries/
require 'sequel'
require 'mysql2'
require 'colorize'
require 'colorized_string'


MYSQL_HOSTS = %w(gcs-data.mysql.database.azure.com localhost 192.168.1.104 70.61.131.182)
MYSQL_USER  =  %w(BrianPurgert@gcs-data mft_data)  #'mft_data'
MYSQL_PASS  = "GoV321CoN"
basedir                     = File.join(__dir__,'./helpers/')
helpers                 = Dir.glob(basedir+"*.sql")

def line
	puts "-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-".colorize(:white)
end



count = 0
begin
	puts "Connecting to #{MYSQL_HOSTS[count]}"
	@client = Mysql2::Client.new(username: MYSQL_USER[count], password: 'GoV321CoN', database: "mft_data", host: MYSQL_HOSTS[count], port: 3306, sslverify:false, sslcipher:'AES256-SHA')
	@DB = Sequel.connect(:adapter=>'mysql2', :host=>MYSQL_HOSTS[count], :database=>'mft_data', :user=>MYSQL_USER[count], :password=>'GoV321CoN')
rescue Exception => e
	line
	puts "#{e.message}".colorize(:red)
	count += 1
	retry if count <= MYSQL_HOSTS.size
end

	@DB.extension(:pretty_table)

	# todo: sequel extension      https://github.com/sdepold/sequel-bit_fields
	# todo: sequel extension      https://github.com/earaujoassis/sequel-seed
	# todo: sequel extension      http://shrinerb.com/
	# ------------------------------------------------------------------ #
	#     Create Tables if they need to be
	# ------------------------------------------------------------------ #

helpers.each do |sql|
	contents = File.open(sql, "rb")
	@DB.run contents.read
end

# @DB.create_table? :manufactures do
# 	primary_key :id
# 	String      :name, :null=>false
# 	String      :name, :null=>false
# end

#  varchar(255) not null,
# href_name varchar(255) null,
# category varchar(255) null,
# last_updated datetime default CURRENT_TIMESTAMP not null,
# last_search datetime default CURRENT_TIMESTAMP not null,
# item_count int(10) unsigned null,
#                             check_out bit default b'0' not null,
# id int not null auto_increment
# primary key,
#         priority int(10) default '10' not null



@DB.create_table? :controller! do
	Integer     :stop
end
# @DB[:controller].insert(key: 'stop',value: 0)

	@DB.create_table? :searches do
		primary_key :id
		String      :title
		String      :url
		Integer     :found
	end

	def searched(title,url,found)
		items = @DB[:searches]
		items.insert(title: title,url: url,found: found)
	end

	
	# pp @ DB.schema(:manufactures)
	def display_statistics
		manufacture_parts = @DB[:manufacture_parts]
		manufacture       = @DB[:manufactures]
		line
		color_p "Manufacture Parts count: #{manufacture_parts.count}   Manufacture count: #{manufacture.count}", 7
	end

	def take(queue)
		[].tap { |array| i = 0
			until queue.empty? || i == 1000
				array << queue.pop
				i += 1
			end
		}
	end

	# --------------------------------------------------------------------------------------------------------------- #
	# ---------------------------------------------------------------------------------------------------------------#

	# @mfr_list_time = @client.prepare("UPDATE mft_data.page_mfr_list SET last_update=NOW() WHERE list_for=?")
	# def set_mfr_list_time(letter)
	# 	@mfr_list_time.execute(letter)
	# 	puts "UPDATE COMPLETE:\t#{letter}".colorize(:green)
	# end



	def insert_contractors(mfrs)
		@DB[:contractors].import([:name, :href_name, :category, :item_count], mfrs)
	end

	def insert_manufactures(mfrs)
		@DB[:manufactures].import([:name, :href_name, :category, :item_count], mfrs)
	end

	def insert_mfr_parts(mfr_parts_data)
		@DB[:manufacture_parts].import([:mfr, :mpn, :name, :href_name, :desc, :low_price, :sources], mfr_parts_data)
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
	
	
	def mfr_time(name)
		escaped       = @client.escape("#{name}")
		insert_string = "UPDATE mft_data.manufactures SET last_search=NOW() WHERE name='#{escaped}'"
		puts insert_string.colorize(:green)
		@client.query("#{insert_string}")
	end
	
	

	def check_in
	     insert_string = "UPDATE mft_data.manufactures SET check_out=0 WHERE check_out=1"
	     puts insert_string
	      @client.query("#{insert_string}")
	     # safe_stop
	end

	# def check_in(name)
	# 	escaped = @client.escape("#{name}")
	# 	insert_string = "UPDATE mft_data.manufactures SET check_out=0 WHERE name='#{escaped}'"
	#       @client.query("#{insert_string}")
	# end


	def check_out_parts(n)
		result = @client.query("UPDATE `mft_data`.`mfr_parts` as t,(
		      SELECT href_name
		      FROM `mft_data`.`mfr_parts`
		      WHERE status_id='0'
	            ORDER BY last_updated
	            LIMIT #{n}
			) as temp
			SET status_id = '1' WHERE temp.href_name = t.href_name")
	end

      def get_mfr(amount = 1)
		 if continue
		      queued_set = @DB[:manufactures].filter(check_out: 0).order(Sequel.desc(:priority), :item_count, :name).limit(amount)#.update(priority: 100)
		      up_next = queued_set.all
		      queued_set.update(check_out: 1)
		 else
			 up_next = []
		 end
		  display_statistics
		        # queued_set.print
          return up_next
     end
  # get_mfr(30)

	def get_mfr_part(amount = 1)
		row_list = []
	
		result = @client.query("SELECT * FROM `mft_data`.`mfr_parts` ORDER BY last_updated LIMIT #{amount};", :symbolize_keys => true)
		result.each do |row|
			row_list << row
		end
		mfr_part_href = row_list.map!{|link| link[:href_name]}
		check_out_parts(amount)
		return mfr_part_href
	end


	def load_table_mfr
	@mfr_table = []
	result = @client.query('SELECT * FROM `mft_data`.`mfr` ORDER BY last_updated;')
	result.each do |row|
		@mfr_table  << row
	end
	@mfr_table.each do |mfr|
		print "#{mfr['name']}\t".colorize(:white)
		print "#{mfr['href_name']}\t".colorize(:magenta)
		print "#{mfr['last_updated']}\t".colorize(:blue)
		puts "#{mfr['item_count']}\t".colorize(:green)
	end
end





