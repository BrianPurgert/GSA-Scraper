
ElibMain       = "https://www.gsaelibrary.gsa.gov/ElibMain/"
ContractorList = "contractorList.do?contractorListFor="


ScheduleList   = "scheduleList.do"


# https://www.gsaelibrary.gsa.gov/ElibMain/sinDetails.do?executeQuery=YES&scheduleNumber=51+V&flag=&filter=&specialItemNumber=105+002
# https://www.gsaelibrary.gsa.gov/ElibMain/scheduleSummary.do?scheduleNumber=23+V
# https://www.gsaelibrary.gsa.gov/ElibMain/sinDetails.do?executeQuery=YES&scheduleNumber=70&flag=&filter=&specialItemNumber=132+100
#
# https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-35F-247DA&contractorName=A+%26+T+SYSTEMS%2C+INC.&executeQuery=YES
# https://www.gsaelibrary.gsa.gov/ElibMain/advRedirect.do?contract=GS-35F-247DA&sin=132+40&src=elib&app=cat
#
# https://www.gsaadvantage.gov/advantage/s/vnd.do?q=1:4ADV.BUI*&listFor=C
# https://www.gsaadvantage.gov/advantage/s/refineSearch.do?q=1:4ADV.BUI*&searchType=1&_a=u&_q=24:5C%26H+DISTRIBUTORS%2C+LLC
#
# https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4ADV.BUI*&listFor=C
# https://www.gsaadvantage.gov/advantage/s/refineSearch.do?q=1:4ADV.BUI*&_a=u&_q=28:5C2G
#
# https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?gsin=11000049763004
# https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?contractNumber=GS-35F-0391P&itemNumber=N7H-01023&mfrName=MICROSOFT
# End_Point https://www.gsaadvantage.gov/advantage/contractor/contractor_detail.do?mapName=/s/search/&cat=ADV&contractNumber=GS-35F-0391P



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