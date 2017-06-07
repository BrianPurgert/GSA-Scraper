require_relative 'gsa_advantage'


def get_all_products(gsa_a, mfr_href, n, n_low, pg, total_found)
	begin
		gsa_a[n].browser.goto search_url(mfr_href, n_low)
		
		doc         = Nokogiri::HTML(gsa_a[n].html)
		pagination  = doc.css("#pagination")
		next_page   = pagination.text.include? "Next Page >"
		
		product_tables = doc.search('#pagination~ table:not(#pagination2)')

		n_results   = product_tables.length
		@items      += n_results
	
		
		
		      product_tables.each_with_index do |product_table, i|
			    n_low = parse_result(product_table)
			end
			#THIS MUST GO
			
			pg = pg + 1
			
			# bp [" #{mfr_name}","pg:#{n_results}/#{total_found}","$#{n_low}","#{url}","#{@items}"],[45,15,10,130,14,80,80]
			
	
	end while next_page
end


def parse_result(product_table)
	fssi = product_table.text.include? "GSA Global"
	if fssi
		sources = '1'
	else
		n_source = product_table.css('tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr:nth-child(5) > td > span')
		sources  = n_source.text.gsub(/[^0-9]/, '')
	end
	product   = product_table.search("a.arial[href*='product_detail.do?gsin']")[0]
	name      = product.text.strip
	href_name = product['href']
	# manufacture part number
	mpn       = product_table.css("tbody tr > td font.black8pt").text.strip
	# short description
	desc      = product_table.css('tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(1) > td').text.strip
	# feature price
	price     = product_table.css('span.newOrange.black12pt.arial > strong').text.strip
	price     = normalize_price(price)
	# Mfr
	mfr_span  = product_table.css('tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(2) > td > span.black-text')
	mfr       = mfr_span.text.strip
	@db_queue << [mfr, mpn, name, href_name, desc, price, sources]
	return price
end


1.times do
@reading    = 0
@items      = 0
@db_queue   = Queue.new
@mfr_queue  = Queue.new
threads     = []
display_statistics

#----------Normal-----------------Headless-------------#
Dev_mode ? n_total = 10        : n_total = 20          # Number of Manufactures to search
Dev_mode ? n_thr = 5          : n_thr = 5             # Number of browsers to run
gsa_a     = []


get_mfr(n_total).each {|mfr| @mfr_queue << mfr}

threads << Thread.new do
	while @reading < 10 do
		until @db_queue.empty?
			insert_mfr_parts(take(@db_queue))
			@reading = 0
		end
		@reading += 1
		color_p "-#{@db_queue.length}", 7 if @reading > 5
		sleep 5
	end
end

def parse_results(html)
	 main_alt = Nokogiri::HTML.fragment(html)
	 product_tables = main_alt.search('#pagination~ table:not(#pagination2)')
	 product_tables.each_with_index do |product_table, i|
		 p i
		 parse_result(product_table)
	 end
end



def normalize_price(last_price)
	n_low = last_price[1..-1].tap { |s| s.delete!(',') }
	return n_low.to_f.round(2)
end


n_thr.times do |n|
	threads << Thread.new do
		gsa_a[n] = initialize_browser
			until @mfr_queue.empty?
				mfr = @mfr_queue.shift
				get_all_products(gsa_a, mfr[:href_name], n, 900000000, 1, 0)
			end
		gsa_a[n].browser.close
		end
end



threads.each { |thr| thr.join }


end
















