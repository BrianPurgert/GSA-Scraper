class GsaAdvantagePage
  include PageObject
  page_url('https://www.gsaadvantage.gov/advantage/s/search.do')
  div(:ip_current,                                css:  'body > pre')
  text_field(:search,                id:   	'searchText')
  div(:main,                                      id: 'main')
  link(:first_result,              	css:  	'#main-alt > table > tbody > tr > td:nth-child(3) > table:nth-child(5) > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(1) > td a[href*="product_detail.do?gsin"]:first-child')
  cell(:first_result_container,    	css:  	'#main-alt > table > tbody > tr > td:nth-child(3) > table:nth-child(5) > tbody > tr:nth-child(2) > td:nth-child(2) > table > tbody > tr:nth-child(1) > td > table > tbody > tr:nth-child(1) > td')
  link(:contractor_highlight_link, 	css:  	'table.pricehighlight > tbody > tr:nth-child(2) > td > a')
  span(:contractor_highlight_price,	css:  	'table.pricehighlight > tbody > tr:nth-child(1) > td > span:first-child')
  table(:contractor_highlight_table,	class:	'table.pricehighlight')
  cell(:mft_cell,    	css: '#main > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(3) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2)')
end

# https://github.com/cheezy/page-object/wiki/Elements
# https://github.com/cheezy/page-object/wiki/Indexed-Properties
# main > table:nth-child(3) > tbody > tr > td > table > tbody > tr:nth-child(6) > td:nth-child(2) > table.greybox > tbody > tr:nth-child(2)