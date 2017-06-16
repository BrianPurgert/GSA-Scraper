# Database file
# Sequel ORM
# Why? https://twin.github.io/evaluating-ruby-libraries/
require 'sequel'
require 'mysql2'
require 'colorize'
require 'colorized_string'


MYSQL_HOSTS = %w(localhost 192.168.1.104 70.61.131.182)
MYSQL_USER  = 'mft_data'
MYSQL_PASS  = 'GoV321CoN'
def line
	puts "-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-".colorize(:white)
end

count = 0
begin
	puts "Connecting to #{MYSQL_HOSTS[count]}"
	@client = Mysql2::Client.new(host: MYSQL_HOSTS[count], username: MYSQL_USER, password: MYSQL_PASS,encoding: 'utf8')
	@DB = Sequel.connect("mysql2://#{MYSQL_USER}:#{MYSQL_PASS}@#{MYSQL_HOSTS[count]}/mft_data")
rescue Exception => e
	line
	puts "#{e.message}".colorize(:red)
	line
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


	
	@DB.run "CREATE TABLE IF NOT EXISTS vendors
	(
		name varchar(255) not null
			primary key,
		href_name varchar(255) null,
		last_updated datetime default CURRENT_TIMESTAMP not null,
		last_search datetime default CURRENT_TIMESTAMP not null,
		item_count int(10) unsigned null,
		`change` int(10) default '0' not null,
		check_out bit default b'0' not null,
		constraint manufacture_name_uindex
			unique (name)
	);"

	# TODO: Convert
	@DB.run "CREATE TABLE IF NOT EXISTS manufacture_parts
	(
		id INT(11) NOT NULL AUTO_INCREMENT,
		mfr varchar(255) not null,
		mpn varchar(40) not null,
		name varchar(255) null,
		href_name varchar(255) null,
		low_price varchar(255) null,
		`desc` text null,
		last_updated datetime default CURRENT_TIMESTAMP not null,
		status_id tinyint default '0' not null,
		sources int(10) default '0' null,
		primary key (id)
	);"



	 @DB.run "CREATE TABLE IF NOT EXISTS manufactures
	(
		name varchar(255) not null,
		href_name varchar(255) null,
		category varchar(255) null,
		last_updated datetime default CURRENT_TIMESTAMP not null,
		last_search datetime default CURRENT_TIMESTAMP not null,
		item_count int(10) unsigned null,
		                            check_out bit default b'0' not null,
		id int not null auto_increment
		primary key,
		        priority int(10) default '10' not null
	);"

	@DB.run "CREATE TABLE IF NOT EXISTS contractors
		(
		name varchar(255) not null,
		href_name varchar(255) null,
		category varchar(255) null,
		last_updated datetime default CURRENT_TIMESTAMP not null,
		last_search datetime default CURRENT_TIMESTAMP not null,
		item_count int(10) unsigned null,
		                            check_out bit default b'0' not null,
		id int not null auto_increment
		primary key,
		        priority int(10) default '10' not null
	);"

	
	
	
	# TODO: Remove Convert
	# @DB.run "CREATE TABLE IF NOT EXISTS page_mfr_list
	# (
	# 	list_for char(50) not null
	# 		primary key,
	# 	last_update timestamp default CURRENT_TIMESTAMP not null
	# );"

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
		line
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


	
	
	def mfr_time(name)
		escaped       = @client.escape("#{name}")
		insert_string = "UPDATE mft_data.mfr SET last_search=NOW() WHERE name='#{escaped}'"
		puts insert_string.colorize(:green)
		@client.query("#{insert_string}")
	end
	
	
	def safe_stop
		@client.query("SELECT stop FROM mft_data.control", :symbolize_keys => true).each do |row|
			if row[:stop].to_i == 1
				puts "Safe Stop value from database = 1".colorize(:green)
				ColorizedString.colors.each { |c| print "||".colorize(c) }
				exit
			end
		end
	end


	# def check_in
	#      insert_string = "UPDATE mft_data.manufactures SET check_out=0 WHERE check_out=1"
	#      puts insert_string
	#       @client.query("#{insert_string}")
	#      safe_stop
	# end

	def check_in(name)
		safe_stop
		escaped = @client.escape("#{name}")
		insert_string = "UPDATE mft_data.manufactures SET check_out=0 WHERE name='#{escaped}'"
	      @client.query("#{insert_string}")
	end

	def check_out(name)
		safe_stop
		escaped = @client.escape("#{name}")
		insert_string = "UPDATE mft_data.manufactures SET check_out=1 WHERE name='#{escaped}'"
	      @client.query("#{insert_string}")
	end

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
		manufacture_set = @DB[:manufactures].where(check_out: 0).order(Sequel.desc(:priority)).limit(amount)
		manufacture_set.print
		manufacture_set.update(check_out: 1)
          return manufacture_set.all
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




      def move_empty_queue
		# should use this
          # @client.query('
          #      UPDATE `mft_data`.`mfr`, `mft_data`.`queue`
          #      SET lowest_price_contractor.lowest_contractor = queue.lowest_contractor,
          #          lowest_price_contractor.lowest_contractor_price = queue.lowest_contractor_price,
          #          lowest_price_contractor.lowest_contractor_page_url = queue.lowest_contractor_page_url,
          #          lowest_price_contractor.mpn_page_url = queue.mpn_page_url
          #      WHERE lowest_price_contractor.mpn = queue.mpn;
          #           ')
          # @client.query('TRUNCATE `mft_data`.`queue`;')
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





