require_relative 'gsa_advantage'

def get_html(gsa_a, n, url)
	Mechanized ? (gsa_a[n].get url) : (gsa_a[n].browser.goto url)
	puts url
	Mechanized ? (gsa_a[n].page.body) : (gsa_a[n].html)
end

def get_all_products(gsa_a, mfr, n, n_low, pg)
	begin
		url  = search_url(mfr[:href_name], n_low, mfr[:category])
		# todo: catch this
		# in `fetch': 503 => Net::HTTPServiceUnavailable for http://169.254.0.0/ -- unhandled response (Mechanize::ResponseCodeError)
		html = get_html(gsa_a, n, url)
		save_page(html, url)
		doc            = Nokogiri::HTML(html)
		pagination     = doc.css("#pagination")
		next_page      = pagination.text.include? "Next Page >"
		product_tables = doc.search('#pagination~ table:not(#pagination2)')
		n_results      = product_tables.length
		@items         += n_results
		      product_tables.each_with_index do |product_table, i|
			    n_low = parse_result(product_table)
			end
			pg = pg + 1
		# color_p "#{url}  #{n_results}", 11
		sleep 4
	
	end while next_page
end


# s	Small Business
# o	Other than Small Business
# w	Woman Owned Business
# wo	Women Owned Small Business (WOSB)
# ew	Economically Disadvantaged Women Owned Small Business (EDWOSB)
# v	Veteran Owned Small Business
# dv	Service Disabled Veteran Owned Small Business
# d	SBA Certified Small Disadvantaged Business
# 8a	SBA Certified 8(a) Firm
# h	SBA Certified HUBZone Firm
def business_indicators(product_table)
	# product_table.search("a[href*='BUSINESS_IND']").map(&text.strip)
	product_table.search("a[href*='BUSINESS_IND']").map { |business_indicator| business_indicator.text.strip }
end

def product_image(product_table)
	product_table.css("img[alt='Click to view product details']")['src']
end

def product_symbols(product_table)
	product_table.search("a[href*='SYMBOLS#']").each { |symbol| symbol['href'].split('#').last }
end

def parse_result(product_table)
	# result = {}
	# result[:indicators] = business_indicators(product_table)
	# result[:image] = product_image(product_table)
	# result[:symbols] = product_symbols(product_table)
	#SYMBOLS#fssi #disaster
	
	fssi = product_table.text.include? "GSA Global"
	if fssi
		sources = '1'
	else
		n_source = product_table.css('tr:nth-child(5) > td > span')
		sources  = n_source.text.gsub(/[^0-9]/, '')
	end
	product   = product_table.search("a.arial[href*='product_detail.do?gsin']")[0]
	name      = product.text.strip
	href_name = product['href']
	# manufacture part number
	mpn       = product_table.css("td font.black8pt").text.strip
	# short description
	desc      = product_table.css("td[style='overflow:hidden; text-overflow: ellipsis; ']").text.strip
	# feature price
	price     = product_table.css('span.newOrange.black12pt.arial > strong').text.strip
	price     = normalize_price(price)
	# Mfr
	mfr_span  = product_table.css('span.black-text')
	mfr       = mfr_span.text.strip
	product   = [mfr, mpn, name, href_name, desc, price, sources]
	# puts product.inspect
	@db_queue << product
	return price
end


def add_manufactures(n_total)
	manufactures = get_mfr(n_total)
	manufactures.each do |mfr|
		@mfr_queue << mfr
	end
end

	@reading              = 0
	@items                = 0
	@db_queue   = Queue.new
	@mfr_queue  = Queue.new
	@continue   = continue
	exit unless @continue
Thread.abort_on_exception = false
	threads              = []
n_thr                     = 160 # Number of browsers to run
	gsa_a                = []

	
	threads << Thread.new do
		while @continue do
			if @mfr_queue.size < (n_thr*3)
				add_manufactures(n_thr*5)
			end
			sleep 4
		end
	end
	

	threads << Thread.new do
		i = 0
		while @continue do
			if  @db_queue.size > 10000
				insert_mfr_parts(take(@db_queue))
				color_p "Seconds #{i}", 12
				i = 0
			else
				i = i + 1
				sleep 1
			end
			
		end
				insert_mfr_parts(take(@db_queue))
	end

	def parse_results(html)
		 main_alt = Nokogiri::HTML.fragment(html)
		 product_tables = main_alt.search('#pagination~ table:not(#pagination2)')
		 product_tables.each_with_index do |product_table, i|
			 parse_result(product_table)
		 end
	end

	def normalize_price(last_price)
		n_low = last_price[1..-1].tap { |s| s.delete!(',') }
		return n_low.to_f.round(2)
	end

	
	n_thr.times do |n|
		 # sleep 1
		threads << Thread.new do
			  gsa_a[n] = initialize_browser
			  i = 0
			  while @continue
				until @mfr_queue.empty?
					i += 1
					mfr = @mfr_queue.shift
					puts "Start: #{mfr[:name]} #{mfr[:category]}"
					get_all_products(gsa_a, mfr, n, 900000000, 1)
					# check_in(mfr[:name],mfr[:category])
					puts "Finished: #{mfr[:name]} #{mfr[:category]}"
					if !Mechanized
						gsa_a[n] = restart_browser gsa_a[n] if i % 5 == 0
					end
				end
				  sleep 5
			  end
			end
	end
	


threads.each { |thr| thr.join }
	display_statistics

gsa_a.each do |b|
	begin
	b.close
	rescue
		puts 'Browser already closed'
	end
end

















