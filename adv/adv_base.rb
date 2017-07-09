require_relative 'gsa_advantage'
1.times do
	
	# '1+SOURCE+SOLUTIONS%2C+LLC'
	# '1 SOURCE SOLUTIONS, LLC'
	# '1+SOURCE+SOLUTIONS%2C+LLC'
	
	
threads     = []
gsa_a       = []
config      = [6]

@vnd_queue      = Queue.new
@mfr_queue      = Queue.new
@letter_queue = Queue.new
@reading    = 0

ARGV.each_with_index { |a,i| config[i] = a }
letters = ("A".."Z").to_a << '0'
letters.each {|l| @letter_queue << l}


threads << Thread.new do
	while @letter_queue.empty? && @mfr_queue.empty? && @ do
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
		mfr_link   = item.search("a[href*='refineSearch.do']")[0]
		name_mfr   = mfr_link.text.strip
		href_mfr   = REGEX_QUERY.match(mfr_link['href'])
		puts href_mfr
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
		href_mfr = REGEX_QUERY.match(link.href)
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

	40.times do |i|
	threads << Thread.new do
		gsa_a[i] = initialize_browser
		until @letter_queue.empty?
		letter = @letter_queue.pop
		ADV::Lists.each do |list|
			ADV::Categories.each do |category|
				url = "https://www.gsaadvantage.gov/advantage/s/#{list}q=1:4#{category}*&listFor=#{letter}"
				# puts url
				# Mechanized ? (gsa_a[i].get url) : (gsa_a[i].browser.goto url)
					html = get_html(gsa_a, i, url)
					found = parse_mfr_list(html,list,category)
					# searched ' ',url, found
				@count = @count + found
			end
		end
		end
		 # gsa_a[i].browser.close
	end
end

threads.each { |thr| thr.join }
color_p "#{Time.now} Complete"
benchmark 'Manufactures/Contractors', @count

end




