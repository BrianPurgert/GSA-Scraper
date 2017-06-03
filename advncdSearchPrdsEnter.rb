require_relative 'gsa_advantage'
require "net/http"
require "uri"
require "httparty"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


base_url    = "https://www.gsaadvantage.gov/"
search      = "advantage/s/search.do?"
"q=0:1#{any_product_field}"
"&q=9,8:1#{mfr_part_number}"
"&q=11,12:0#{product_name_description}"
"&q=11:1#{product_name}"
"&q=10:1#{manufacturer}"
"&q=19:1#{contract_number}"
"&q=24:1#{contractor}"
"&q=23:1""#{category_name}"
"&q=20:1#{sin}"
"&q=0:2#{any_product_field}"


POST /advantage/s/advncdSearchPrdsEnter.do HTTP/1.1
Host: www.gsaadvantage.gov
Connection: keep-alive
Content-Length: 342
Pragma: no-cache
Cache-Control: no-cache
Origin: https://www.gsaadvantage.gov
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.71 Safari/537.36
Content-Type: application/x-www-form-urlencoded
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8
Referer: https://www.gsaadvantage.gov/advantage/s/advncdSearchPrdsEnter.do
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.8
Cookie: JSESSIONID=80B08AD6A7BDF7DB623CC49646CE424C.F0; _ga=GA1.2.1232212143.1495287996; _gid=GA1.2.1532774134.1496360674


q:24:13M*
q:9,8:3XXXXXX

org.apache.struts.taglib.html.TOKEN:8fdf3ee1ee81fe9cbcd44351fec2b398



# Use the class methods to get down to business quickly
# response = HTTParty.get('https://www.gsaadvantage.gov/advantage/s/search.do?q=28:5ABILITYONE-OUTLOOK-NEBRASKA%2C+INC.&q=14:7900000000&c=100&s=9&p=1')
# puts response.body, response.code, response.message, response.headers.inspect

# Or wrap things up in your own class
r_proxy       = Proxy_list.sample
#{r_proxy}
response = HTTParty.get('https://www.gsaadvantage.gov/advantage/s/search.do?q=28:5ABILITYONE-OUTLOOK-NEBRASKA%2C+INC.&q=14:7900000000&c=100&s=9&p=1', { http_proxyaddr: "69.162.164.78", http_proxyport: "45623", :timeout => 3 })
q=9,8:3XXXXXX
puts response.body, response.code, response.message, response.headers.inspect

# https://johnnunemaker.com/httparty/
class AdvRecord
	include HTTParty
	base_uri 'api.stackexchange.com'
	def initialize(service, page)
		@options = { query: { site: service, page: page } }
	end

	def questions
		self.class.get("/2.2/questions", @options)
	end

	def users
		self.class.get("/2.2/users", @options)
	end
end

# stack_exchange = AdvRecord.new("stackoverflow", 1)
# puts stack_exchange.questions
# puts stack_exchange.users


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
"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
"Accept-Encoding: gzip, deflate, br"
"Accept-Language: en-US,en;q=0.8"
"Cookie: JSESSIONID=84150BFA0A734F1A8695654BA993FDE5.E3; _ga=GA1.2.1232212143.1495287996; _gid=GA1.2.270594689.1496287038; _gat_GSA_ENOR0=1"



#
# <select name="advRecordNames.matchByCriteriaNamesIndexed[4]">
# <option value="2" selected="selected">any the words</option>
#                         <option value="0">all the words</option>
# <option value="1">the exact phrase</option>
#                         <option value="3">none of the words</option></select>
#
#                     <input type="text" name="advRecordNames.typedCriteriaInputNamesIndexed[4]" maxlength="80" size="25" value="">
#                       <strong>in</strong>
# <select name="advRecordNames.fieldTypeCriteriaNamesIndexed[4]"><option value="0" selected="selected">any product field</option>
#                         <option value="9,8">NSN or mfr part number</option>
# <option value="11,12">product name or description</option>
#                         <option value="11">product name</option>
# <option value="10">manufacturer</option>
#                         <option value="19">contract number</option>
# <option value="24">contractor</option>
#                         <option value="27">vendor p/n</option>
#                         <option value="23">category name</option>
# <option value="20">Special Item Number (SIN)</option>
# </select>
