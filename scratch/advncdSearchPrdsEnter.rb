

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




r_proxy       = Proxy_list.sample
#{r_proxy}
response = HTTParty.get('https://www.gsaadvantage.gov/advantage/s/search.do?q=28:5ABILITYONE-OUTLOOK-NEBRASKA%2C+INC.&q=14:7900000000&c=100&s=9&p=1', { http_proxyaddr: "69.162.164.78", http_proxyport: "45623", :timeout => 3 })
puts response.body, response.code, response.message, response.headers.inspect

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


