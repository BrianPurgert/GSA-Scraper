

require 'rubygems'
require 'mechanize'
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

a = Mechanize.new { |agent|
	agent.user_agent_alias = 'Mac Safari'
}

a.get('http://en.wikipedia.org/') do |page|
	search_result = page.form_with(:id => 'searchform'){ |frm|
		frm.search = 'U.S.'
	}.submit
	
	puts search_result.parser.css('h1').text
end





base_url    = "https://www.gsaadvantage.gov/"
search      = "advantage/s/search.do?"
# a="q=0:1#{any_product_field}"
# m="&q=9,8:1#{mfr_part_number}"
# p="&q=11,12:0#{product_name_description}"
# p="&q=11:1#{product_name}"
# m="&q=10:1#{manufacturer}"
# c="&q=19:1#{contract_number}"
# c="&q=24:1#{contractor}"
# c="&q=23:1""#{category_name}"
# s="&q=20:1#{sin}"
# a="&q=0:2#{any_product_field}"







# uri = URI.parse("http://google.com/")
# response = Net::HTTP.get_response(uri)
# puts "/n Response Body /n#{response.body}"


# GET /advantage/s/advncdSearchPrdsEnter.do HTTP/1.1
# Host: www.gsaadvantage.gov
# Connection: keep-alive
# Pragma: no-cache
# Cache-Control: no-cache
# Upgrade-Insecure-Requests: 1
# User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.71 Safari/537.36
# "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"


