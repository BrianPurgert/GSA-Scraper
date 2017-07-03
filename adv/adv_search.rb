require_relative 'gsa_advantage'

@reading   = 0
@items     = 0
@throttle  = 5
@db_queue  = Queue.new
@mfr_queue = Queue.new

threads = []
n_thr   = 50
gsa_a   = []


def get_html(gsa_a, n, url)
	if MECHANIZED then
		page = gsa_a[n].get url
		puts "Agent #{n} received Code: #{page.code}" unless page.code == 200
		# in `fetch': 503 => Net::HTTPServiceUnavailable for http://169.254.0.0/ -- unhandled response (Mechanize::ResponseCodeError)
		page.body
	else
		gsa_a[n].browser.goto url
		gsa_a[n].html
	end
end

def get_all_products(gsa_a, mfr, n, n_low, pg)
	begin
		sleep @throttle
		url  = search_url(mfr[:href_name], n_low, mfr[:category])
		
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
	end while next_page
end


# TODO controller
def controller
	@throttle = @DB[:controller].filter(key: 'throttle').select(:value).first
	sleep 20
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

# ------------------------------------- #

@continue = continue
exit unless @continue

	threads << Thread.new do
		while @continue do
			if @mfr_queue.size < (n_thr*2)
				add_manufactures(n_thr*6)
			end
			sleep 1 # TODO hard coded sleep
		end
	end
	

	threads << Thread.new do
		while @continue do
			color_p "DB Queue #{@db_queue.size}", 12
			if @db_queue.size > 1000
				insert_mfr_parts(take(@db_queue))
			else
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
		n_low.to_f.round(2)
	end


def search(gsa_a, n)
	i = 0
	while @continue
		until @mfr_queue.empty?
			i   += 1
			mfr = @mfr_queue.shift
			# puts "Start: #{mfr[:name]} #{mfr[:category]}"
			get_all_products(gsa_a, mfr, n, 900000000, 1)
			# check_in(mfr[:name],mfr[:category])
			# puts "Finished: #{mfr[:name]} #{mfr[:category]}"
			unless MECHANIZED
				gsa_a[n] = restart_browser gsa_a[n] if i % 5 == 0
			end
		end
		puts "Queue is Empty"
	end
end

n_thr.times do |n|
	threads << Thread.new do
		gsa_a[n] = initialize_browser
		search(gsa_a, n)
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

















