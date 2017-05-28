require_relative 'gsa_advantage'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

1.times do
@reading    = 0
@items      = 0
@db_queue   = Queue.new
@mfr_queue  = Queue.new
threads     = []
n_thr          = 16 # Number of browsers to run
n_total        = 1000 # Number of Manufactures to search
test_search = FALSE



get_mfr(n_total).each {|mfr| @mfr_queue << mfr}
gsa_a     = []


threads << Thread.new do
	while @reading < 10 do
		color_p "\t\t\t\tQueue empty: #{30-@reading}\tt Queued: #{@db_queue.length} ", 7
		sleep 5
	end
end

def take(queue)
	[].tap do |array|
		i = 0
		until queue.empty? || i == 300
			array << queue.pop
			i += 1
		end
	end
end

threads << Thread.new do
	while @reading < 10 do
		until @db_queue.empty?
			insert_mfr_parts(take(@db_queue))
			sleep 1
			@reading = 0
		end
		@reading += 1
		sleep 3
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

		# product_table.include? "GSA Global"
		if product_table.text.include? "GSA Global Supply"
			sources = '1'
			puts "GSA Global\nGSA Global\nGSA Global\nGSA Global\nGSA Global\nGSA Global"
		else
			n_source = product_table.css('tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr:nth-child(5) > td > span')
			sources = n_source.text.gsub(/[^0-9]/, '')
		end
		# TODO remove this later
		sources = '1' if sources.empty?

		# puts "#{mfr} #{mpn} #{name} #{low_price} #{href_name}  PN: #{mpn} | #{sources} #{i}"
		#  bp ["MFR: #{mfr}  PN: #{mpn}"," $#{low_price} S#{sources} C#{i}","NAME: #{name}","#{href_name}"]
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
	gsa_a[n] = initialize_browser
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
		begin
			url             = search_url(mfr_href, n_low)
			gsa_a[n].browser.goto url
			# TODO: check to make sure we're on the right page
			# pagin     = gsa_a[n].browser.table(css: "#pagination")
			# next_page = pagin.text.include? "Next Page >"
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
					color_p "#{n}\t | #{title} | Low: #{n_low}\n#{url}", n
					# save_page(html, gsa_a[n].browser.url, "#{mfr_href}-#{pg}")
				end


		end while n_results > 99
		
	end
	gsa_a[n].browser.close
			end

end



threads.each { |thr| thr.join }


end
















