require 'page-object'
require 'watir'
require 'page-object/page_factory'
require 'spreadsheet'
require_relative 'pages/gsa_advantage_page'
require 'mysql2'
require 'sharepoint-ruby'

site = Sharepoint::Site.new 'govconsvcs.sharepoint.com', 'MD'
site.session.authenticate 'brianpurgert', 'JBM123!@#'
lists = site.lists
for l in lists
	puts l.title
end

# book = Spreadsheet::Workbook.new
# sheet1 = book.create_worksheet
# sheet2 = book.create_worksheet :name => 'My Second Worksheet'
# sheet1.name = 'Price'
# sheet1.row(0).concat %w{Name Country Acknowlegement}
# sheet1[1,0] = 'Japan'
# row = sheet1.row(1)
# row.push 'Creator of Ruby'
# row.unshift 'Yukihiro Matsumoto'
# sheet1.row(2).replace [ 'Daniel J. Berger', 'U.S.A.',
#                         'Author of original code for Spreadsheet::Excel' ]
# sheet1.row(3).push 'Charles Lowe', 'Author of the ruby-ole Library'
# sheet1.row(3).insert 1, 'Unknown'
# sheet1.update_row 4, 'Hannes Wyss', 'Switzerland', 'Author'
#
# sheet1.row(0).height = 18
#
# format = Spreadsheet::Format.new :color => :blue,
#                                  :weight => :bold,
#                                  :size => 18
# sheet1.row(0).default_format = format
#
# bold = Spreadsheet::Format.new :weight => :bold
# 4.times do |x| sheet1.row(x + 1).set_format(0, bold) end
#
# book.write 'excel-file.xls'

sleep 100
mfr_list_pages = ("A".."Z").to_a << "0"
puts mfr_list_pages
sleep 10
testst = "https://www.gsaadvantage.gov/advantage/s/refineSearch.do;jsessionid=F47E648BFB6508CEBD083ABD30A4CFCB.F4?q=1:4*&_a=u&_q=28:5SCOTSMAN"
rx_mfr = /(?<=\q=28:5).*/
puts rx_mfr.match()

sleep 200
whitespace =""

client = Mysql2::Client.new(
		host:     "70.61.131.180",
		username: "mft_data",
		password: "GoV321CoN",
		flags:    Mysql2::Client::MULTI_STATEMENTS)

  browser = Watir::Browser.new :chrome
  gsa_advantage = GsaAdvantagePage.new(browser)
  gsa_advantage.browser.goto 'https://brianpurgert.com'
sleep 10




# mft_data.lowest_price_contractor.mpn
# mft_data.lowest_price_contractor.manufacturer_name
# mft_data.lowest_price_contractor.lowest_contractor
# mft_data.lowest_price_contractor.lowest_contractor_price
# mft_data.lowest_price_contractor.lowest_contractor_page_url
# mft_data.lowest_price_contractor.mpn_page_url

all_sql_data = client.query('
SELECT *
FROM `mft_data`.`lowest_price_contractor`;
')
#
result.each_with_index  do |row, index|
		puts "#{index}\t#{row}"
end

client.query('
INSERT INTO
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')

result = client.query('
SELECT *
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')

result = client.query('
INSERT INTO manufacturer_name
VALUES ()
FROM `mft_data`.`lowest_price_contractor`
WHERE lowest_contractor IS NULL ;
')


result.each_with_index  do |row, index|
  puts "#{index}\t#{row}"
end





# basedir = './../Input-Files/'
# files = Dir.glob(basedir+"*.xls")
# files.each_with_index do |file, num|
#   puts "#{num}   #{file}"
# end
# pick_num = gets.to_i
# puts files[pick_num]
sleep 100

proxy_list = %w(
  104.151.234.175:8080
  104.151.234.176:8080
  104.151.234.177:8080
  104.151.234.178:8080
  104.151.234.179:8080
  104.151.234.180:8080
  104.151.234.170:8080
  23.106.254.173:29842
  23.106.254.89:29842
  172.241.136.212:29842
  23.106.254.219:29842
  172.241.136.164:29842
  23.106.254.252:29842
  104.151.234.171:8080
  104.151.234.172:8080
  104.151.234.173:8080
  104.151.234.174:8080
  104.151.234.181:8080
  104.151.234.182:8080
  104.151.234.183:8080
  104.151.234.184:8080
  104.151.234.185:8080
  104.151.234.186:8080
  104.151.234.187:8080
  104.151.234.188:8080
  104.151.234.189:8080
)

# browser = []
# gsa_advantage = []
#
# proxy_list.each_with_index do |proxy, index|
# 	puts proxy
# 	puts index
#   browser[index] = Watir::Browser.new :chrome, switches: ["--proxy-server=#{proxy}"]
#   gsa_advantage[index] = GsaAdvantagePage.new(browser[index])
#   gsa_advantage[index].browser.goto 'http://www.ipaddresslocation.org/'
# end
