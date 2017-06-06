require 'mysql2'
require 'colorize'
require 'colorized_string'
require 'sequel'


@client = Mysql2::Client.new(host: "hudson.govcon.local", username: "mft_data", password: "GoV321CoN",encoding: 'utf8')

@DB = Sequel.connect('mysql2://mft_data:GoV321CoN@hudson.govcon.local/mft_data')

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

	@DB.run "CREATE TABLE IF NOT EXISTS manufacture_parts
	(
		mfr varchar(255) not null,
		mpn varchar(40) not null,
		name varchar(255) null,
		href_name varchar(255) null,
		low_price varchar(255) null,
		`desc` text null,
		last_updated datetime default CURRENT_TIMESTAMP not null,
		status_id tinyint default '0' not null,
		sources int(10) null,
		primary key (mfr, mpn)
	);"

	@DB.run "CREATE TABLE IF NOT EXISTS mfr
	(
		name varchar(255) not null
			primary key,
		href_name varchar(255) null,
		last_updated datetime default CURRENT_TIMESTAMP not null,
		last_search datetime default CURRENT_TIMESTAMP not null,
		item_count int(10) unsigned null,
		`change` int(10) default '0' not null,
		check_out bit default b'0' not null,
		last_low_price float default '90000000' null,
		constraint manufacture_name_uindex
			unique (name)
	);"
	
	@DB.run "CREATE TABLE IF NOT EXISTS page_mfr_list
	(
		list_for char(50) not null
			primary key,
		last_update timestamp default CURRENT_TIMESTAMP not null
	);"

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

	
	# puts DB.schema(:mfr_parts)
	def display_statistics
		@manufacture_parts = @DB[:mfr_parts]
		@manufacture       = @DB[:mfr]
		puts "Manufacture Parts count: #{@manufacture_parts.count} Average Price: #{@manufacture_parts.avg(:low_price)}"
		puts "Manufacture count: #{@manufacture.count}"
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
	# Everything below this line needs to be converted to use the Sequel Gem
	# ---------------------------------------------------------------------------------------------------------------#

	@mfr_list_time = @client.prepare("UPDATE mft_data.page_mfr_list SET last_update=NOW() WHERE list_for=?")
	def set_mfr_list_time(letter)
		@mfr_list_time.execute(letter)
		puts "UPDATE COMPLETE:\t#{letter}".colorize(:green)
	end


	#TODO Save searched urls to database
	@insert_manufacture = @client.prepare("REPLACE INTO mft_data.mfr(name, href_name, item_count) VALUES (?, ?, ?)")
	def insert_mfr(name,href_name,item_count=1)
		# puts "#{name} | #{href_name} | #{item_count}"
		@insert_manufacture.execute("#{name}","#{href_name}","#{item_count}")
	end

	def insert_manufactures(mfrs)
		insert_string = 'REPLACE INTO mft_data.mfr(name, href_name, item_count)
				         VALUES'
		mfrs.each_with_index do |mfr, i|
			insert_string += ',' if i > 0
			insert_string +=   "('#{@client.escape(mfr[0])}','#{@client.escape(mfr[1])}','#{mfr[2]}')\n"
		end
		# puts insert_string.colorize(:green)
		@client.query("#{insert_string}", cast: false)
	end

	@insert_part = @client.prepare("REPLACE INTO mft_data.mfr_parts (mfr, mpn, name, href_name, `desc`, low_price, sources) VALUES (?, ?, ?, ?, ?, ?, ?)")
	def insert_mfr_part(part)
            @insert_part.execute(part[0],part[1],part[2],part[3],part[4],part[5],part[6])
		# puts "REPLACE COMPLETE:\t#{part.inspect}".colorize(:green)
            end

	def insert_mfr_parts(mfr_parts_data)
          insert_string = 'REPLACE INTO mft_data.mfr_parts (mfr, mpn, name, href_name, `desc`, low_price, sources)
			         VALUES'
          mfr_parts_data.each_with_index do |mfr_part, i|
               insert_string += ',' if i > 0
               insert_string +=   "('#{@client.escape(mfr_part[0])}','#{@client.escape(mfr_part[1])}','#{@client.escape(mfr_part[2])}','#{@client.escape(mfr_part[3])}','#{@client.escape(mfr_part[4])}','#{@client.escape(mfr_part[5])}','#{@client.escape(mfr_part[6])}')\n"
          end
          # puts insert_string.colorize(:green)
          @client.query("#{insert_string}", cast: false)
     end

	
	def insert_result_block(mfr_parts_data)
		insert_string = 'REPLACE INTO mft_data.mfr_part_blocks (href_search, result_block, href_name)
				         VALUES'
		mfr_parts_data.each_with_index do |mfr_part, i|
			insert_string += ',' if i > 0
			insert_string += "('#{@client.escape(mfr_part[0])}','#{@client.escape(mfr_part[1])}','#{@client.escape(mfr_part[2])}')\n"
		end
		puts insert_string.colorize(:green)
		@client.query("#{insert_string}")
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


	def check_out(name)
		safe_stop
		escaped = @client.escape("#{name}")
		insert_string = "UPDATE mft_data.mfr SET check_out=1 WHERE name='#{escaped}'"
		puts insert_string.colorize(:green)
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

	def check_in
	     insert_string = "UPDATE mft_data.mfr SET check_out=0 WHERE check_out=1"
	     puts insert_string
	      @client.query("#{insert_string}")
	     safe_stop
	end

      def get_mfr(amount = 1)
          row_list = @client.query("SELECT * FROM `mft_data`.`mfr` WHERE check_out=0 ORDER BY item_count DESC LIMIT #{amount};", :symbolize_keys => true).to_a
          row_list.each do |row|
	          print row
	          check_out(row[:name]) if IS_PROD
          end

          mfr_href = row_list.map{|mfr| mfr[:href_name]}
          return row_list
     end

	def get_mfr_part(amount = 1)
		row_list = []
	
		result = @client.query("SELECT * FROM `mft_data`.`mfr_parts` ORDER BY last_updated LIMIT #{amount};", :symbolize_keys => true)
		result.each do |row|
			row_list << row
		end
		mfr_part_href = row_list.map!{|link| link[:href_name]}
		if IS_PROD
			check_out_parts(amount)
		end
		return mfr_part_href
	end



def get_mfr_list(amount = 1)
	row_list = []
	result = @client.query("SELECT list_for FROM `mft_data`.`page_mfr_list` ORDER BY last_update LIMIT #{amount};", :symbolize_keys => true)
	result.each { |row| row_list << row }
	mfr_list = row_list.map!{|link| link[:list_for]}
	p mfr_list.inspect
	return mfr_list
end




      def move_empty_queue
          @client.query('
               UPDATE `mft_data`.`mfr`, `mft_data`.`queue`
               SET lowest_price_contractor.lowest_contractor = queue.lowest_contractor,
                   lowest_price_contractor.lowest_contractor_price = queue.lowest_contractor_price,
                   lowest_price_contractor.lowest_contractor_page_url = queue.lowest_contractor_page_url,
                   lowest_price_contractor.mpn_page_url = queue.mpn_page_url
               WHERE lowest_price_contractor.mpn = queue.mpn;
                    ')
          @client.query('TRUNCATE `mft_data`.`queue`;')
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





