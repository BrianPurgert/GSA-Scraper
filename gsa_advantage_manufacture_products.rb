require_relative 'gsa_advantage'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

@reading    = 0
@items      = 0
@db_queue   = Queue.new
@mfr_queue  = Queue.new
threads     = []
n_thr     = 1 # Number of browsers to run
n_each    = 2 # Number of Manufactures to search per browsers
test_search = FALSE

n_total   = n_thr * n_each
get_mfr(n_total).each {|mfr| @mfr_queue << mfr}
gsa_a     = []

threads << Thread.new do
	while @reading < 10 do
		until @db_queue.empty?
			 mfr_part = @db_queue.shift
			 insert_mfr_part(mfr_part)
			@reading = 0
		end
		@reading += 1
		color_p "Queue empty: #{@reading}/10", 7
		sleep 5
	end
end


def get_parent(mpn, mfr)
	pr = mpn.parent
	puts pr.element.text
	c = 0
	until pr.text.include? mfr || c == 4
		pr = pr.parent
	end
	puts pr.html
	pr.scroll_into_view
	pr.highlight
	return [pr]
end


# Nokogiri Product Parser
def parse_results(html)                                                             # input html from #main-alt
	 main_alt = Nokogiri::HTML.fragment(html)
	 product_tables = main_alt.search('#pagination~ table:not(#pagination2)')
	 color_p "number of product_tables: #{product_tables.size}"
	 product_tables.each_with_index do |product_table, i|
		product = product_table.search("a.arial[href*='product_detail.do?gsin']")[0]
		name = product.text.strip
		href_name = product['href']
		# manufacture part number 70006459310
		mpn = product_table.css("tbody tr > td font.black8pt").text.strip
		# short description
		desc = product_table.css('tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(1) > td').text.strip
		# feature price
		price = product_table.css('span.newOrange.black12pt.arial > strong').text.strip
		low_price = price[1..-1].tap { |s| s.delete!(',') }
		# Mfr
		mfr_span = product_table.css('tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(2) > td > span.black-text')
		mfr = mfr_span.text.strip
		# Sources
		if mfr.include? 'N/A' # GSA Global Supply
			sources = 1
		else
			n_source = product_table.css('tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr:nth-child(5) > td > span')
			sources = n_source.text.gsub(/[^0-9]/, '')
		end
		# color_p "MFR: #{mfr} PN: #{mpn} | #{name} | Price: #{low_price} | #{href_name} | PN: #{mpn} | #{sources} #{i}"
		bp ["MFR: #{mfr}"," PN: #{mpn}"," #{name}"," Price: #{low_price} ","#{href_name}"," #{sources} #{i}"]
		@db_queue << [mfr, mpn, name, href_name, desc, low_price, sources]
	 end
end

# Watir Product Parser
def read_product(container)
	 container.flash
	# Product
		product = container.link(css:"a.arial[href*='product_detail.do?gsin']")
	# Product link
		href_name = product.href
	# Product name
		name = product.text
	# manufacture part number 70006459310
		part = container.font(css: 'tbody tr > td font.black8pt')
		mpn = part.text
	# short description
		short_desc = container.td(css: 'tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(1) > td')
		desc = short_desc.text
	# feature price
		price = container.strong(css: 'span.newOrange.black12pt.arial > strong')
		low_price = price.text[1..-1].tap { |s| s.delete!(',') }
	# Mfr
		mfr_span = container.span(css: 'tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(2) > td > span.black-text')
		mfr = mfr_span.text
	# Sources
		if mfr.include? 'N/A' # GSA Global Supply
			sources = 1
		else
			n_source = container.span(css: 'tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr:nth-child(5) > td > span')
			sources = n_source.text.gsub(/[^0-9]/, '')
		end
	# product image href
	# 	img = container.img(css: '[href*="product_detail.do?gsin"] img')
	#     img.flash

		product.flash
		part.flash
		short_desc.flash
		price.flash
		mfr_span.flash
		n_source.flash
		@db_queue << [mfr, mpn, name, href_name, desc, low_price, sources]
end


def normalize_price(last_price)
	n_low = last_price[1..-1].tap { |s| s.delete!(',') }
	n_low = n_low.to_f.round(2)
end


n_thr.times do |n|
	threads << Thread.new do
	gsa_a[n] = initialize_browser(n,n_thr)
	until @mfr_queue.empty?
		mfr = @mfr_queue.shift
		mfr_name       = mfr[:name]
		mfr_href       = mfr[:href_name]
		mfr_item_count = mfr[:item_count]
		pg             = 1
		n_low          = 900000000
		o_low          = 990000000
		combined_html  = ''
		color_p "Begin Search -- #{mfr_name} | Items: #{mfr_item_count}",n
		p @db_queue.size
		begin
			url             = search_url(mfr_href, n_low)
			gsa_a[n].browser.goto url
			pagin     = gsa_a[n].browser.table(css: "#pagination")
			next_page = pagin.text.include? "Next Page >"
			results         = gsa_a[n].browser.tables(css: "#pagination~ table:not(#pagination2)")
			n_results       = results.length
	
			title       = gsa_a[n].browser.title
			url         = gsa_a[n].browser.url
			
				if n_results > 0
					n_low      = normalize_price(gsa_a[n].ms_low_price_elements.last.text)
					result_section = gsa_a[n].browser.div(id: 'main-alt')
					parse_results(result_section.html)
					
					if test_search
						results.each { |c| read_product(c) }
					end
					pg         = pg + 1
					color_p "#{n}\t | #{title} |#{n_low}\n#{url}", n
					# save_page(html, gsa_a[n].browser.url, "#{mfr_href}-#{pg}")
				end
			
			
		end while n_results > 99
		
	end
		end
end



threads.each { |thr| thr.join }


# initialize_browsers()
# (0..3).each do |index|
# 	puts "Companies Processed: #{index}".colorize(:red)
# 	search_on_browser(1, get_mfr)
# end

# @semaphore = Mutex.new
#  @threads = []
#  t_count = 0;
# (0..2000).each do |index|
#      thr_n = index % N_threads_plus_one
#       puts "thr_n #{thr_n}"
#  	    t_count = t_count+1
#  	    @threads << Thread.new do
#  		    search_on_browser(thr_n, get_mfr)
#  	    end
#      if t_count >= N_threads
#  	    @threads.each { |t| t.join if t != Thread.current }
#  	    t_count = 0
#      end
#  end
#  Thread.list.each { |t| t.join if t != Thread.current }




















