require_relative 'gsa_advantage'

	require 'rubygems'
	require 'sequel'
	require 'open-uri'
	
Sequel::Model.plugin :update_or_create
Sequel::Model.plugin :csv_serializer
Sequel::Model.plugin :many_through_many

CATALOG = Sequel.connect(adapter:    "mysql2",
                       database:   'catalog',
                       host:       ENV['MYSQL_HOST'],
                       user:       ENV['MYSQL_USER'],
                       password:   ENV['MYSQL_PASS'])

CATALOG_LT = Sequel.sqlite

CATALOG.extension(:pretty_table)
CATALOG_LT.extension(:pretty_table)



CATALOG_LT.create_table?(:gsin)do
	primary_key :id
end

# class GSIN < Sequel::Model
# 	one_to_many :product, :key=>:id
# end
#
# class Product < Sequel::Model
# 	many_to_one :GSIN
# end


CATALOG_LT.create_table? :products do
	primary_key :id
	String :gsin             ,null: false
	String :contractor       ,null: false
	String :contract_number  ,null: false
	String :vendor_part      ,null: false
	String :manufacture      ,null: false
	String :bpa_number       ,null: false
	Float :price             ,null: false
	String :unit             ,null: false
	String :features         ,null: false
	String :photo            ,null: false
	String :delivery         ,null: false
	String :fob_shipping     ,null: false
end

CATALOG_LT[:products].print
@DB[:manufacture_parts].select(10)


# TODO Extract links /advantage/catalog/product_detail.do?contractNumber=GS-21F-0010W&itemNumber=5017-11&mfrName=HUTCHINS ALLIANCE COATINGS INC.
# TODO split product_detail{ contractNumber:      GS-21F-0010W , itemNumber: 5017-11, mfrName: HUTCHINS ALLIANCE COATINGS INC.}


products = CATALOG_LT[:products]
100.times do |i|

end



# Step 1 Load GSIN only with simple array Use
gsin_queue = Queue.new
 [11000011151811,11000050589433,11000044674011,11000044675013,11000043883398,11000007925152,11000044676885,11000044674054, 11000044673543].each{ |gsin| gsin_queue << gsin}

product_agents = []
product_agent  = initialize_browser
product_agents << product_agent
 gsin_queue
product_url    = "#{GSA_ADVANTAGE}#{PRODUCT_DETAIL}gsin=#{gsin_queue.pop}&cview=true"
puts product_url
html           = get_html(product_agents, 0, product_url)
puts html
doc            = Nokogiri::HTML(html)



exit
url_set.in_threads(n_thr).each_with_index do |urls, i|
	gsa_a[i] = initialize_browser
	urls.each do |url|
		gsa_a[i].browser.goto "#{url}&cview=true"


		text = gsa_a[i].main
		html = gsa_a[i].main_element.html
		gsin = save_page(html, gsa_a[i].browser.url, text)
		color_p "#{i}|#{title} | #{gsin}",i
		end
end


# html.delete! "\n"
# comments = html.split("<!--")
# comments.each { |comment| comment.strip!; color_p comment }
# "hello".start_with?("heaven", "hell")
# "  hello  ".rstrip   #=> "  hello"
# "  hello  ".lstrip   #=> "hello  "


# experience for customers and give you an edge when it comes down to the customer's final purchase decision.  Customers using GSA
# Advantage can also limit their search results to only those products with photos. Please note the following:
# - You can now provide multiple photos per product or accessory to show different views.
# - Your photos should be well-lit, crisp and clear and show the entire product where the product takes up to 80% of the photo area.
# - Photos should be at least 500x500 pixels but we recommend they be at least 800x800 pixels in size for detail viewing. (note:  GSA
#   Advantage will create thumbnails of your images when smaller size is shown).
# - Photos must be in either JPG or GIF format.  Maximum photo file size is 1MB.  File size cannot be 0.
# - Maximum file name size is 80 characters and should contain only letters, numbers, and underscores.
# - Photos must be located in your SIPv7\PHOTO subdirectory.