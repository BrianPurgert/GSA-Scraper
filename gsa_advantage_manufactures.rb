require_relative 'adv/gsa_advantage'
1.times do



threads     = []
gsa_a       = []
config      = [6]
@vnd_queue      = Queue.new
@mfr_queue      = Queue.new
@reading    = 0
@letter_queue = Queue.new

ARGV.each_with_index { |a,i| config[i] = a }
letters = ("A".."Z").to_a << '0'
letters.each {|l| @letter_queue << l}


threads << Thread.new do
	while @reading < 10 do
		until @mfr_queue.empty?
			insert_manufactures(take(@mfr_queue))
			@reading = 0
		end
		until @vnd_queue.empty?
			insert_contractors(take(@vnd_queue))
			@reading = 0
		end
		@reading += 1
		color_p "End in: #{10-@reading}", 7 if @reading > 5
		sleep 10
	end
end

def parse_mfr_list(html, list_type, category)
	list = Nokogiri::HTML.fragment(html)
	items = list.search('table > tbody > tr > td > span')
	items.each_with_index do |item, i|
		mfr_link = item.search("a[href*='refineSearch.do']")[0]
		name_mfr = mfr_link.text.strip
		href_mfr = RX_mfr.match(mfr_link['href'])
		n_products = item.css(".gray8pt").text.strip.delete('()')

		# bp ["#{name_mfr}","#{href_mfr}","#{n_products}","#{@queue.size}"],[40,40,5,6]
		if list_type == "vnd.do?"
		@vnd_queue << [name_mfr.to_s,href_mfr.to_s,category,n_products.to_i]
		else
		@mfr_queue << [name_mfr.to_s,href_mfr.to_s,category,n_products.to_i]
		end
	end
	return items.size
end

def test_mfr_list(gsa_a)
	gsa_a.mft_table_element.links.each do |link|
		href_mfr = RX_mfr.match(link.href)
		# link.flash
		link.flash
		name_mfr = link.text
		e_products = link.parent.following_sibling
		e_products.flash
		n_products = e_products.text
		n_products = n_products.delete('()')
		@queue << [name_mfr,href_mfr,n_products]
	end
end
@count = 0
benchmark '', @count

	
	6.times do |i|
	threads << Thread.new do
		gsa_a[i] = initialize_browser
		until @letter_queue.empty?
		letter = @letter_queue.pop
		ADV::Lists.each do |list|
			ADV::Categories.each do |category|
				url = "https://www.gsaadvantage.gov/advantage/s/#{list}q=1:4#{category}*&listFor=#{letter}"
				p url
				gsa_a[i].browser.goto url
				found = parse_mfr_list(gsa_a[i].mft_table_element.html, list, category)
				searched gsa_a[i].browser.title,gsa_a[i].browser.url, found
				@count = @count + found
			end
		end
		end
		gsa_a[i].browser.close
	end
end

threads.each { |thr| thr.join }
color_p "#{Time.now} Complete"
benchmark 'Manufactures/Contractors', @count

end




