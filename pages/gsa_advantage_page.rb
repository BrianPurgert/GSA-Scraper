# helper stylesheet https://userstyles.org/styles/142221/pretty-gsa-advantage
class GsaAdvantagePage
	include PageObject

	# def goto url
	# 	self.browser.goto url
	# end
	# User Alerts
	# Session Terminated
	
	page_url('https://www.gsaadvantage.gov/advantage/search/headerSearch.do')
     
     # /advantage/s/mfr.do?q=1:4*&listFor=
		table(:mft_table, css: '#main > table > tbody > tr:nth-child(2) > td:nth-child(2) > table:nth-child(3)')
		links(:mfr_link,  css: 'a[href*="refineSearch.do"]')

     # /advantage/s/search.do?
		bs(:product_detail, css: 'a[href*="product_detail.do?gsin"] > :not(img)')
		links(:product_link,  css: 'a.arial[href*="product_detail.do?gsin"]')
		link(:single_product,  css: 'a[href*="product_detail.do?gsin"]')
		images(:product_thumb, css: 'a[href*="product_detail.do?gsin"] img')
		table(:pagination, id: '#pagination')
		fonts(:ms_mpn, css: 'tbody tr > td font.black8pt')
		links(:ms_low_price, css: 'span.newOrange.black12pt.arial > strong')
		cells(:ms_desc, css: 'tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(1) > td')
		spans(:ms_sources, css: 'table tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr > td > span')
		div(:main_alt, id: 'main-alt')
	
     
     # /advantage/catalog/product_detail.do? gsin=11000019481346 mfrName=3M
		div(:main, id: 'main')
		link(:contractor_highlight_link, css: 'table.pricehighlight > tbody > tr:nth-child(2) > td > a')
		span(:contractor_highlight_price, css: 'table.pricehighlight > tbody > tr:nth-child(1) > td > span:first-child')
		table(:contractor_highlight_table, class: 'table.pricehighlight')

     # remove these /advantage/s/search.do?
			link(:first_result, css: '#main-alt > table > tbody > tr > td:nth-child(3) > table:nth-child(5) > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(1) > td a[href*="product_detail.do?gsin"]:first-child')
			cell(:first_result_container, css: '#main-alt > table > tbody > tr > td:nth-child(3) > table:nth-child(5) > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(1) > td')
end


