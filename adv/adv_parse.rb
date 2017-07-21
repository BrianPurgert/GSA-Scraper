def parse_list(html, list_type, category)
	doc = Nokogiri::HTML(html)
	items = doc.css('#main  td:nth-child(n) > span')
	items.each do |item|
		link      = item.at_css("a[href*='advantage']")
		href      = link['href']
		decoded   = link.text.strip
		encoded   = REGEX_QUERY.match(href)
		
		product_count = item.css(".gray8pt").text.strip.delete('()')
		
		color_p %W(#{decoded} #{encoded} #{product_count}), 13
		if list_type == "vnd.do?"
			@vnd_queue << [decoded.to_s,encoded.to_s,category,product_count.to_i]
		else
			@mfr_queue << [decoded.to_s,encoded.to_s,category,product_count.to_i]
		end
	end
	return items.size
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

# 38 possible symbols [href*='keyName=SYMBOLS#']
def product_symbols(product_table)
	product_table.search("a[href*='SYMBOLS#']").each { |symbol| symbol['href'].split('#').last }
end

def contractor(url)

end

def normalize_price(last_price)
	n_low = last_price[1..-1].tap { |s| s.delete!(',') }
	n_low.to_f.round(2)
end

def parse_result(product_table)
	# Determine what type of page we are parsing
	# Search Page?
	# Product Page?
	
	 # result              = {}
	 # result[:indicators] = business_indicators(product_table)
	 # result[:image]      = product_image(product_table)
	 # result[:symbols]    = product_symbols(product_table)
	 # result[:contractor] = contractor(product_table)
	 # puts result.inspect
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
	gsin = href_name.split('=').last
	product   = [mfr, mpn, name, gsin, desc, price, sources]
	# puts product.inspect
	@db_queue << product
	return price
end

def parse_results(html)
	main_alt       = Nokogiri::HTML.fragment(html)
	product_tables = main_alt.search('#pagination~ table:not(#pagination2)')
	product_tables.each_with_index do |product_table, i|
		parse_result(product_table)
	end
end