class GsaAdvantagePage
	include PageObject
	page_url('https://www.gsaadvantage.gov/')
     
     # /advantage/s/mfr.do?q=1:4*&listFor=
          table(:mft_table, css: '#main > table > tbody > tr:nth-child(2) > td:nth-child(2) > table:nth-child(3)')
     
     # /advantage/s/search.do?
	     link(:ms_name, css: 'td a[href*="product_detail.do?gsin"]:first-child')
          link(:product_detail, css: 'a.arial[href*="product_detail.do?gsin"]')
          link(:ms_low_price, css: 'span.newOrange.black12pt.arial > strong')
          cell(:ms_desc, css: 'tbody > tr:nth-child(2) > td:nth-child(3) > table > tbody > tr:nth-child(1) > td')
          span(:ms_sources, css: 'table tbody > tr:nth-child(2) > td:nth-child(1) > table > tbody > tr > td > span')
     
     # /advantage/catalog/product_detail.do?gsin=
          div(:main, id: 'main')
          link(:contractor_highlight_link, css: 'table.pricehighlight > tbody > tr:nth-child(2) > td > a')
          span(:contractor_highlight_price, css: 'table.pricehighlight > tbody > tr:nth-child(1) > td > span:first-child')
          table(:contractor_highlight_table, class: 'table.pricehighlight')

     # special case /advantage/s/search.do?
          link(:first_result, css: '#main-alt > table > tbody > tr > td:nth-child(3) > table:nth-child(5) > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(1) > td a[href*="product_detail.do?gsin"]:first-child')
          cell(:first_result_container, css: '#main-alt > table > tbody > tr > td:nth-child(3) > table:nth-child(5) > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(1) > td')
end

# a.arial[href*="product_detail.do?gsin"]{
#      background-color: rgba(0, 136, 204, 0.3);
#      box-shadow:0px 0px 1px 15px rgba(0, 136, 204, 0.3);
# }

