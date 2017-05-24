require_relative 'gsa_advantage'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

@reading    = 0
@db_queue   = Queue.new
@mfr_queue  = Queue.new
threads     = []
n_thr     = 4 #4 browsers
n_each    = 2

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
		sleep 10
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

def parse_results(html)
	html = HtmlBeautifier.beautify(html,"\t\t")
	# p html
	doc = Nokogiri::HTML(html)
	puts "### Search for nodes by css"
	 doc.css('#pagination~ table:not(#pagination2)').each do |container|
	 	# print container.

	 end
end

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

		# product.flash
		# part.flash
		# short_desc.flash
		# price.flash
		# mfr_span.flash
		# n_source.flash
		@db_queue << [mfr, mpn, name, href_name, desc, low_price, sources]
end

n_thr.times do |n|
	threads << Thread.new do
	gsa_a[n] = initialize_browser(n,n_thr)
	until @mfr_queue.empty?
		mfr = @mfr_queue.shift
		p mfr.inspect
		# puts "Search Start:\t#{mfr['name']}    gsa_advantage:\t#{gsa_advantage[n]}"
		mfr_name       = mfr[:name]
		mfr_href       = mfr[:href_name]
		mfr_item_count = mfr[:item_count]
		pg             = 1
		n_low          = 900000000
		begin
			url         = search_url(mfr_href, n_low)
			gsa_a[n].browser.goto url
			title       = gsa_a[n].browser.title
			url         = gsa_a[n].browser.url
			# links       = gsa_a[n].product_link_elements
			results     = gsa_a[n].browser.tables(css: "#pagination~ table:not(#pagination2)")
			n_results   = results.length
			result_set = []
			# TODO trigger refresh if needed... gsa_a[n].browser.refresh

			case n_results
				when 0
					raise "Missing results #{gsa_a[n].browser.url}"
				when 1..100
				#main-alt > table > tbody > tr > td:nth-child(3)
				# result_section = gsa_a[n].browser.div(id: 'main-alt')
				# parse_results(result_section.html)
				# p 'test done'
				# Current scraper, fast for a human but slow for 5+ million results..
					results.each do |container|
						  read_product(container)
					end
					
					#  gsa_a[n].product_link_elements.each_with_index do |link|
					# 	 link.flash(color: "rgba(255, 0, 0, 0.6)",flashes: 1, persist: TRUE)
					# 	      @db_queue  << [mfr, mpn, name, href_name, `desc`, low_desc, low_price]
					# end
					
					last_price = gsa_a[n].ms_low_price_elements.last.text
					n_low  = last_price[1..-1].tap { |s| s.delete!(',') }
					n_low += 0.01 # this is to account for the items on the next page being the same price.
					 f_name = "#{mfr_href}-#{pg}"
					  # save_page(html, gsa_a[n].browser.url, f_name)
					pg = pg + 1
					 color_p "#{n}\t|#{f_name} |\t #{title} |#{n_low}\n#{url[30..-10]}",n
				else
					puts "error in number of results on page, n_results: #{n_results}"
			end
		end while n_results == 100
		
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




















