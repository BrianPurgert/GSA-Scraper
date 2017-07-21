# URI resolutions for GSA resources

module GSA
	require 'rubygems'
	require 'sequel'
	require 'open-uri'
	require 'uri'


class Advantage
	# @param [String] url
	def initialize(url)
		url.include? "/advantage/"
		# puts URI.decode(url)
		build(url)
	end

	def build(url)
		query        = url.split('/').last
		@page        = query.split('?').first
		query_string = query.split('?').last
		
		if @page.include? "/s/"
			puts "XXXXXXXXX"

			query_string.split('&').each do |part|
				puts part
			end

		end



			
			if @page.include? "product_detail.do"
			query_string.split('&').each do |part|
				if part.include? "gsin"
					@gsin = part.split('=').last
				elsif part.include? "contractNumber"
					@contnum = part.split('=').last
				elsif part.include? "itemNumber"
					@vendpart = part.split('=').last
				elsif part.include? "mfrName"
					@mfgname = part.split('=').last
				elsif part.include? "bpaNumber"
					@bpanum = part.split('=').last
				end
		end
		
		

			@url = "https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?contractNumber=#{@contnum}&itemNumber=#{@mfgpart}&mfrName=#{@mfgname}"

		end
		# /advantage/contractor/contractor_detail.do?mapName=/s/search/&cat=ADV&contractNumber=GS-21F-0072Y
	end

	def contnum
		@contnum
	end

	def bpanum
		@bpanum
	end

	def gsin
		@gsin
	end

	def mfgname
		@mfgname
	end

	def mfgpart
		@mfgpart
	end

	def url
			@url
	end

end
end

require 'pp'

test_urls = %w(
	contractNumber=GS-21F-161AA&itemNumber=PC1400&mfrName=DURACELL&bpaNumber=GS-23F-BA016"
	/advantage/catalog/product_detail.do?contractNumber=GS-02F-0023X&itemNumber=DURPC1400&mfrName=DURACELL+U.S.A.
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
/advantage/s/refineSearch.do?q=1:4*&searchType=1&_a=u&_q=24:5G-FORCE+POWERSPORTS%2C+LLC
https://www.gsaadvantage.gov/advantage/s/refineSearch.do?q=1:4*&searchType=1&_a=u&_q=24:5GALAXIE+DEFENSE+MARKETING+SERVICES
https://www.gsaadvantage.gov/advantage/s/refineSearch.do?q=1:4*&searchType=1&_a=u&_q=24:5GALAXY+INTEGRATED+TECHNOLOGIES%2C+INC
/advantage/s/refineSearch.do?q=1:4*&searchType=1&_a=u&_q=24:5GOVSOLUTIONS%2C+INC.
/advantage/s/refineSearch.do?q=1:4*&searchType=1&_a=u&_q=24:5GRAPHICADD+SUPPLIES%2C+INC.
/advantage/s/refineSearch.do?q=1:4*&searchType=1&_a=u&_q=24:5GRAY+MANUFACTURING+COMPANY%2C+INC.


)


test_array = []

test_urls.each_with_index do |url, i|
	test_array[i] = GSA::Advantage.new(url)
	# puts test_array[i].gsin
	puts test_array[i].url
  #"#{test_array[i].gsin} #{test_array[i].mfgpart} #{test_array[i].mfgname} #{test_array[i].contnum} #{test_array[i].bpanum}"
end

