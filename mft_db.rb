require 'mysql2'
require 'colorize'
require 'colorized_string'

     @client = Mysql2::Client.new(
          host:     "70.61.131.180",
          username: "mft_data",
          password: "GoV321CoN",
          reconnect: true,
          read_timeout: 20,
          write_timeout: 25,
          connect_timeout: 25,
          cast: false
     )

	def insert_mfr(name,href_name,item_count=1)
		insert_string = "REPLACE INTO mft_data.mfr(name, href_name, item_count) VALUES (?, ?, ?)"
          @insert_manufacture = @client.prepare(insert_string)
		puts "#{name} | #{href_name} | #{item_count}"
          @insert_manufacture.execute("#{name}","#{href_name}","#{item_count}")
     end

	def insert_mfr_parts(mfr_parts_data)
          insert_string = 'REPLACE INTO mft_data.mfr_parts (mfr, mpn, name, href_name, low_price, `desc`)
			         VALUES'
          mfr_parts_data.each_with_index do |mfr_part, i|
               insert_string += ',' if i > 0
               insert_string +=   "('#{@client.escape(mfr_part[0])}','#{@client.escape(mfr_part[1])}','#{@client.escape(mfr_part[2])}','#{@client.escape(mfr_part[3])}','#{@client.escape(mfr_part[4])}','#{@client.escape(mfr_part[5])}')\n"
          end
          puts insert_string.colorize(:green)
          @client.query("#{insert_string}")
     end

	def insert_result_block(mfr_parts_data)
          insert_string = 'REPLACE INTO mft_data.mfr_part_blocks (href_search, result_block, href_name)
			         VALUES'
          mfr_parts_data.each_with_index do |mfr_part, i|
               insert_string += ',' if i > 0
               insert_string +=   "('#{@client.escape(mfr_part[0])}','#{@client.escape(mfr_part[1])}','#{@client.escape(mfr_part[2])}')\n"
          end
          puts insert_string.colorize(:green)
          @client.query("#{insert_string}")
     end

      def mfr_time(name)
	     escaped = @client.escape("#{name}")
	     insert_string = "UPDATE mft_data.mfr SET last_updated=NOW() WHERE name='#{escaped}'"
          puts insert_string.colorize(:green)
          @client.query("#{insert_string}")
     end

	def safe_stop
 @client.query("SELECT stop FROM mft_data.control", :symbolize_keys => true).each do |row|
	 if row[:stop].to_i == 1
		 puts "Safe Stop value from database = 1".colorize(:green)
		 ColorizedString.colors.each {|c| print "||".colorize(c)}
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
          # row_list = []
          row_list = @client.query("SELECT * FROM `mft_data`.`mfr` WHERE check_out=0 ORDER BY last_updated LIMIT #{amount};", :symbolize_keys => true).to_a
          row_list.each do |row|
               # row_list << row
                check_out(row[:name])
          end


          mfr_href = row_list.map{|mfr| mfr[:href_name]}
          return row_list
     end

	def get_mfr_part(amount = 1)
		row_list = []
	
		result = @client.query("SELECT * FROM `mft_data`.`mfr_parts` WHERE status_id=0 ORDER BY last_updated LIMIT #{amount};", :symbolize_keys => true)
		result.each do |row|
			row_list << row
		end
		mfr_part_href = row_list.map!{|link| link[:href_name]}
		check_out_parts(amount)
		return mfr_part_href
	end

def get_mfr_list(amount = 1)
	row_list = []

	result = @client.query("SELECT list_for FROM `mft_data`.`page_mfr_list` ORDER BY last_update LIMIT #{amount};", :symbolize_keys => true)
	result.each do |row|
		insert_string = "UPDATE mft_data.page_mfr_list SET last_update=NOW() WHERE list_for='#{row[:list_for]}'"
		puts insert_string.colorize(:green)
		@client.query("#{insert_string}")
		row_list << row
	end
	mfr_list = row_list.map!{|link| link[:list_for]}
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





