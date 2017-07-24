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


CATALOG.extension(:pretty_table)


# https://www.gsaadvantage.gov/advantage/catalog/product_detail.do?contractNumber=GS-07F-9158S&itemNumber=RM-4E-5PK&mfrName=SOFTWARE+HOUSE
#main_img , .black8pt .black8pt , #TabbedPanels1 div


DB.create_table? :products do
	primary_key :id
	String :gsin             ,null: true
	String :contract_number  ,null: true
	String :item_number      ,null: true
	String :mfr_name         ,null: true
	String :contractor       ,null: true
	Float  :price            ,null: true
	# String :unit             ,null: true
	# String :features         ,null: true
	# String :photo            ,null: true
	# String :delivery         ,null: true
	# String :fob_shipping     ,null: true
end

DB[:products].print
 deduplicate_table(DB, :manufacture_parts, [:href_name])





# TODO Extract links /advantage/catalog/product_detail.do?
# contractNumber=GS-21F-0010W&itemNumber=5017-11&mfrName=HUTCHINS ALLIANCE COATINGS INC.
# TODO split product_detail{ contractNumber:      GS-21F-0010W , itemNumber: 5017-11, mfrName: HUTCHINS ALLIANCE COATINGS INC.}



# Step 1 Load GSIN only with simple array Use

gsin_queue     = Queue.new
gsins          = DB[:manufacture_parts].select(:href_name).limit(50)
gsins.each { |gsin| puts gsin }
gsins.each{ |gsin| gsin_queue << gsin}


product_agents = []

product_agent  = initialize_browser
product_agents << product_agent

until gsin_queue.empty?
  puts "--------------------------"
  gsin = gsin_queue.pop
product_url    = "#{GSA_ADVANTAGE}#{PRODUCT_DETAIL}gsin=#{gsin}&cview=true"
html           = get_html(product_agents, 0, product_url)
doc            = Nokogiri::HTML(html)

	p doc.css("input[name*='cartKey']").map(&:name)

doc.css("a[href*='product_detail.do']:not([href*='oid='])").each do |el|
	# el[:href].split

	# {gsin: gsin,
	#  contract_number:
	# vendor_part:
	# manufacture:
	# bpa_number:
	# contractor:
	# price:
	# unit:
  # }
  #  puts "#{el.text}  #{el['href']}"
end


	doc.css("*[href*='contractNumber=']").each do |el|
		# puts "#{el.text}  #{el['href']}"
	end
end
# input[name*='cartKey']
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
