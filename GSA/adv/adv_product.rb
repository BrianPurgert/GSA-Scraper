require_relative 'gsa_advantage'
include ADV

@gsin_queue     = Queue.new
@import_queue   = Queue.new
threads         = []

def vendor_product_detail(product_agents, product_href)
  html = send_agent(product_href)
  doc = Nokogiri::HTML(html)
  vendor_link = doc.css("a[href*='contractor_detail.do'][href*='?']").first
  vendor_href = clean_href(vendor_link['href'])
  vendor_text = vendor_link.text
  bad = "#main > table:nth-child(3) > tbody > tr > td > table > tbody > tr:nth-child(1) > td:nth-child(2)"
  vendor_product_detail = doc.css(bad)
end


DB.create_table! :products do
	primary_key :id
	String :GSIN             ,null: true
	String :CONTNUM          ,null: true
  String :VENDNAME        ,null: true
	String :MFGNAME      ,null: true
	String :MFGPART         ,null: true
	String :BPANUM       ,null: true
  String :PRICE       ,null: true
  String :PHOTO       ,null: true
  # w v d s ew dv h wo 8a o
	 # String :unit             ,null: true
	 # String :features         ,null: true
	 # String :photo            ,null: true
	 # String :delivery         ,null: true
	 # String :fob_shipping     ,null: true
end




DB[:products].print


# Step 1 Load GSIN
def product_search
  @search_in = 'q=1:4'
  DB.create_table!(:product_search, :as => DB[:manufacture_parts].select(:href_name).distinct(:href_name))
  DB[:product_search].print
  DB[:product_search].each { |product| @gsin_queue  << product[:href_name] }
end

product_search


threads << Thread.new do
  while true
    @import_queue
          sleep 10
          unless @import_queue.empty?
            DB[:products].import([:GSIN, :CONTNUM,:VENDNAME, :MFGNAME, :MFGPART, :BPANUM, :PRICE, :PHOTO], take(@import_queue))
          end
        end
    end
100.times do
  threads << Thread.new do
    initialize_browser
  end
end

20.times do
  threads << Thread.new do

until @gsin_queue.empty?


  # puts "------------------------------------------"
  gsin = @gsin_queue.pop

# Go to Master Product Page "GSIN"
  product_url    = "#{GSA_ADVANTAGE}#{PRODUCT_DETAIL}gsin=#{gsin}&cview=true"
  html           = send_agent(product_url)
  doc            = Nokogiri::HTML(html)
  puts "|#{gsin}| #{product_url }"


  # Rows
  doc.css('table.greybox tr:nth-child(2n)').each do |vendor_row|

    product_vendor = {
        gsin: gsin,
        contract_number: '',
        name: '',
        manufacture: '',
        manufacture_part: '',
        bpa_number: '',
        price: '',
        photo: ''
    }


   dollar_values = vendor_row.css('strong').map do |strong|
                    if (strong.text.size > 0) && (strong.text.include? '$')
                      normalize_price(strong.text.strip)
                    end
                  end
    product_vendor[:price] = dollar_values[0]

    # /images/products/GS-07F-0100W/SCS_PHOTO_4484438.JPG
    # /images/products/GS-07F-0100W/l/SCS_PHOTO_4484438_500x500.JPG
    # /images/products/GS-07F-0100W/i/SCS_PHOTO_4484438_40x40.JPG

    # /images/products/GS-21F-161AA/i/SCS_PHOTO_13482825_40x40.JPG
    # /images/products/GS-21F-161AA/l/SCS_PHOTO_13482825_500x500.JPG


    vendor_row.css("img[src*='images'][src*='products']").each {|image| product_vendor[:photo] = image['src']}

    vendor_row.css("a[href*='contractNumber']:not([href*='gsin']):not([href*='oid=']):not([href*='keyName='])").each do |link|
      if link.text.size > 0
        product_vendor[:name] = link.text
      end
    end

    vendor_row.css("*[href*='contractNumber']").each do |link|
      product_href = clean_href(link['href'])
      query = product_href.split('?').last
      query.split('&').each do |parameter|
        if parameter.include? 'contractNumber'
          product_vendor[:contract_number] = parameter.split('=').last
        elsif parameter.include? 'itemNumber'
          product_vendor[:manufacture_part] = parameter.split('=').last
        elsif parameter.include? 'mfrName'
          product_vendor[:manufacture] = parameter.split('=').last
        elsif parameter.include? 'bpaNumber'
          product_vendor[:bpa_number] = parameter.split('=').last
        end
      end
    end

    # DB[:master_product].insert([:GSIN, :CONTNUM,:VENDNAME, :MFGNAME, :MFGPART, :BPANUM, :PRICE, :PHOTO],
    @import_queue << [product_vendor[:gsin],
      product_vendor[:contract_number],
      product_vendor[:name],
      product_vendor[:manufacture],
      product_vendor[:manufacture_part],
      product_vendor[:bpa_number],
      product_vendor[:price],
      product_vendor[:photo]]
  end

end
  end
end

threads.each { |thr| thr.join }

# html.delete! "\n"
# comments = html.split("<!--")
# comments.each { |comment| comment.strip!; puts comment }
# doc.css("a[href*='product_detail.do']:not([href*='oid='])").each do |el|
# doc.css("*[href*='contractNumber=']").each do |el|

# p doc.css("input[name*='cartKey']").map(&:value)

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
