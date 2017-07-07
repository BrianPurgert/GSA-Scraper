class AdvURL
	# @param [String] url
	def initialize(url)
		@url = url
		build
	end
	
	
	def build
		query  = @url.split('/').last
		@page  = query.split('?').first
		@parms = query.split('?').last
		@parms.split('&').each do |part|
			puts part
		end
		# /advantage/contractor/contractor_detail.do?mapName=/s/search/&cat=ADV&contractNumber=GS-21F-0072Y
	end
	
	def gsin
		split_url = @url.chomp('&cview=true')
		split_url.each_line('=') { |s|
			if s.include? '11'
				return s
			end }
		return false
	end


end


require 'pp'

test_urls = %w(
https://www.gsaadvantage.gov/advantage/s/search.do?q=24%3A5C%26H+DISTRIBUTORS%2C+LLC&searchType=1&c=100s=6
https://www.gsaadvantage.gov/advantage/s/search.do?db=0&q=24%3A5C%26H+DISTRIBUTORS%2C+LLC&searchType=0&c=100&s=8
/advantage/contractor/contractor_detail.do?mapName=/s/search/&cat=ADV&contractNumber=GS-21F-0072Y
/advantage/catalog/product_detail.do?contractNumber=GS-21F-0072Y&itemNumber=PC1500BKD&mfrName=DURACELL+PRO+DIV+OF+P+%26+G
https://www.gsaadvantage.gov/advantage/s/vnd.do?q=1:4ADV.BUI*&listFor=C
https://www.gsaadvantage.gov/outage.html?q=28:5DOLPHIN+COMPONENTS+CORP&c=100&s=9&p=1&listFor=All
gsaadvantage.gov/advantage/catalog/product_detail.do?gsin=11000005279906
https://gsaadvantage.gov/advantage/catalog/product_detail.do?gsin=11000006606835
https://gsaadvantage.gov/advantage/catalog/product_detail.do?gsin=11000001036890
https://gsaadvantage.gov/advantage/catalog/product_detail.do?contractNumber=GS-07F-0100W&itemNumber=10942B&mfrName=E.K.+EKCESSORIES
https://gsaadvantage.gov/advantage/catalog/product_detail.do?contractNumber=GS-25F-0139M&itemNumber=10942B&mfrName=EK+EKCESSORIES
https://www.gsaadvantage.gov/outage.html?contractNumber=GS-35F-4085D&itemNumber=BAL-BA100
/advantage/catalog/product_detail.do?gsin=11000000399674
/advantage/catalog/product_detail.do?gsin=11000000399676
/advantage/catalog/product_detail.do?gsin=11000000399676
/advantage/catalog/product_detail.do?gsin=11000000399678
/advantage/catalog/product_detail.do?gsin=11000000399678
/advantage/catalog/product_detail.do?gsin=11000000399680
/advantage/catalog/product_detail.do?gsin=11000000399680
/advantage/catalog/product_detail.do?gsin=11000000871992
/advantage/catalog/product_detail.do?gsin=11000000939566
/advantage/catalog/product_detail.do?gsin=11000000939567
/advantage/catalog/product_detail.do?gsin=11000000939739
/advantage/catalog/product_detail.do?gsin=11000000939739
)


test_array = []
test_urls.each_with_index do |url, i|
	test_array[i] = AdvURL.new(url)
	# puts test_array[i].gsin
	puts test_array[i].inspect
end