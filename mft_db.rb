require 'mysql2'

class MftDb
     @client = Mysql2::Client.new(
          host:     "70.61.131.180",
          username: "mft_data",
          password: "GoV321CoN",
          reconnect: true,
          cast: false
     )
     @insert_manufacture = @client.prepare("INSERT IGNORE INTO mft_data.mfr(name, href_name, item_count) VALUES (?, ?, ?)")
     
     # TODO yeah
     # @insert_search_result = @client.prepare("INSERT IGNORE INTO mft_data.mfr_parts(mfr, mpn, desc) VALUES (?, ?, ?)")

     
     def insert_mfr(name,href_name,item_count=1)
          @insert_manufacture.execute("#{name}","#{href_name}",'1')
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
     
end