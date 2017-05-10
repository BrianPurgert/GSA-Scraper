require 'mysql2'

     @client = Mysql2::Client.new(
          host:     "70.61.131.180",
          username: "mft_data",
          password: "GoV321CoN",
          reconnect: true,
          cast: false
     )

     def insert_mfr(name,href_name,item_count=1)
          @insert_manufacture = @client.prepare("INSERT IGNORE INTO mft_data.mfr(name, href_name, item_count) VALUES (?, ?, ?)")
          @insert_manufacture.execute("#{name}","#{href_name}",'1')
     end

     def insert_mfr_parts(mfr_parts_data)
          insert_string = 'REPLACE INTO mft_data.mfr_parts
          (mfr, mpn, name, href_name, low_price, `desc`)
           VALUES'
          mfr_parts_data.each_with_index do |mfr_part, i|
               insert_string += ',' if i > 0
               insert_string += " ('#{mfr_part[0]}', '#{mfr_part[1]}', '#{@client.escape(mfr_part[2])}', '#{mfr_part[3]}', '#{mfr_part[4]}', '#{@client.escape(mfr_part[5])}')"
          end
          puts insert_string
          @client.query("#{insert_string}")

     end

     def mfr_time(name)
	     insert_string = "UPDATE mft_data.mfr SET last_updated=NOW() WHERE name='#{name}'"
          puts insert_string
          @client.query("#{insert_string}")
     end

def check_out(name)
     insert_string = "UPDATE mft_data.mfr SET check_out=1 WHERE name='#{name}'"
     puts insert_string
     @client.query("#{insert_string}")
end


     def get_mfr
          row_list = []
          @client.query("SELECT * FROM `mft_data`.`mfr` WHERE check_out=0 ORDER BY last_updated LIMIT 1;", :symbolize_keys => true).each do |row|
               row_list << row
          end
          mfr = row_list[0]
          check_out(mfr[:name])
          return mfr
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





