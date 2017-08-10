
ElibMain       = "https://www.gsaelibrary.gsa.gov/ElibMain/"
ContractorList = "contractorList.do?contractorListFor="
ScheduleList   = "scheduleList.do"

def get_queries(href)
  query = href.split('?').last
  query.split('&')
end

def get_query(href, name)
  value = ''
  get_queries(href).each do |query|
    if query.include? "#{name}="
      value = query.split('=').last
    end
  end
  value
end

def clean_href(href)
   "#{href.split('.do').first}.do?#{href.split('?').last}"
end

def contract(href)

end

def sin(href)
  sin = get_query(href, 'specialItemNumber')
  sin = get_query(href, 'sin') if sin.empty?
  sin
end

def search_criteria(doc)
  category = doc.at_css('#criteria').text.split('ia:').last
  category.strip!
  category
end

def parse_list(html)
	doc = Nokogiri::HTML(html)
  category = search_criteria(doc)
  if doc.css("a[href*='/advantage/s/'][href*='vnd.do']").size > 0
    list_type = 'vnd.do?'
  else
    list_type = 'mfr.do?'
  end

	items = doc.css('#main  td:nth-child(n) > span')
  puts "#{items.size} | #{list_type} | #{category}"
	items.each do |item|
		link      = item.at_css("a[href*='advantage']")
		href      = link['href']
		decoded   = link.text.strip
		encoded   = REGEX_QUERY.match(href)
		
		product_count = item.css(".gray8pt").text.strip.delete('()')
		 # puts %W(#{decoded} #{encoded} #{product_count}), 13
		if list_type == 'vnd.do?'
      @queue[:contractors] << [decoded.to_s,encoded.to_s,category,product_count.to_i]
    elsif list_type == 'mfr.do?'
      @queue[:manufactures] << [decoded.to_s,encoded.to_s,category,product_count.to_i]
    else

		end
	end

end

def page_name(doc)
  doc.at_css("#breadcrumb strong").text.strip
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
	product_table.search("a[href*='BUSINESS_IND']").map { |business_indicator| business_indicator.text.strip }
end

def product_image(product_table)
	product_table.at_css("img[alt*='product'][alt*='details']")['src']
end

# 38 possible symbols [href*='keyName=SYMBOLS#']
def product_symbols(product_table)
	product_table.search("a[href*='SYMBOLS#']").map { |symbol| symbol['href'].split('#').last }
end

def normalize_price(last_price)
	n_low = last_price[1..-1].tap { |s| s.delete!(',') }
	n_low.to_f.round(2)
end

def follow_result(product_table, search_term)
	# Determine what type of page we are parsing
	# Search Page?
	# Product Page?
	   result              = {}
	#   result[:indicators] = business_indicators(product_table)
	#   result[:image]      = product_image(product_table)
	#   result[:symbols]    = product_symbols(product_table)
	  # result[:contractor] = contractor(product_table)
	  # puts result.inspect
     product_table.css('span').each do |item|
       if item.text.include? 'sources'
         result[:sources] = item.text.gsub(/[^0-9]/, '')
       elsif item.text.include? '$'
         result[:price]   = normalize_price(item.text.strip)
       end

     end

	    product   = product_table.search("a[href*='product_detail.do'][href*='gsin']")[0]
      # product   = product_table.search("a[href*='product_detail.do'][href*='contract']")[0]
	name      = product.text.strip
	href_name = clean_href(product['href'])
	# manufacture part number
	mpn       = product_table.css("td font.black8pt").text.strip
	# short description
	# desc      = product_table.css("td[style='overflow:hidden; text-overflow: ellipsis; ']").text.strip
	# feature price
	price     = product_table.css('span.newOrange.black12pt.arial > strong').text.strip
	price     = normalize_price(price)
	# Mfr
	mfr_span  = product_table.css('span.black-text')
	mfr       = mfr_span.text.strip
	gsin = href_name.split('=').last
	product   = [mfr, mpn, name, gsin, search_term, result[:price], result[:sources]]
	# puts product.inspect
	@db_queue << product
	return price
end

def parse_results(html, search_term)
	main_alt       = Nokogiri::HTML.fragment(html)
	product_tables = main_alt.search('#pagination~ table:not(#pagination2)')
	product_tables.each_with_index do |product_table, i|
		follow_result(product_table, search_term)
	end
end