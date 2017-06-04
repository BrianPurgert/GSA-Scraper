require_relative 'gsa_advantage'


threads     = []
gsa_a       = []
config      = [6]
@queue      = Queue.new
@reading    = 0

ARGV.each_with_index { |a,i| config[i] = a }
letters = get_mfr_list(config[0])
# letters = ['X','Y']

threads << Thread.new do
	while @reading < 10 do
		until @queue.empty?
			insert_manufactures(take(@queue))
			@reading = 0
		end
		@reading += 1
		color_p "End in: #{10-@reading}\t Queued: #{@queue.length} ", 7 if @reading > 5
		sleep 3
	end

end

def parse_mfr_list(html)
	list = Nokogiri::HTML.fragment(html)
	items = list.search('table > tbody > tr > td > span')
	items.each_with_index do |item, i|
		mfr_link = item.search("a[href*='refineSearch.do']")[0]
		name_mfr = mfr_link.text.strip
		href_mfr = RX_mfr.match(mfr_link['href'])
		n_products = item.css(".gray8pt").text.strip.delete('()')

		# bp ["#{name_mfr}","#{href_mfr}","#{n_products}","#{@queue.size}"],[40,40,5,6]
		@queue << [name_mfr.to_s,href_mfr.to_s,n_products.to_i]
	end
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

def new_tab(browser,url)
	# window = Watir::Window.new browser.driver,
	# p browser.window.inspect, browser.window.title, browser.window.url
	 browser.driver.execute_script("window.open(arguments[0]);",url)
	# browser.driver.switch_to.window(browser.driver.window_handles.last)
	# p browser.window.inspect, browser.window.title, browser.window.url
end

def use_tab(browser,i)
	browser.driver.switch_to.window(browser.driver.window_handles[i])
	p browser.url
end


# letters = ("A".."Z").to_a << '0'
# p letters
# letters.each do |letter|
#
# end


letters.each_with_index do |letter, i|
	threads << Thread.new do
		gsa_a[i] = initialize_browser
		ADV::Categories.each do |category|
			url = "https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4#{category}*&listFor=#{letter}"
			gsa_a[i].browser.goto url
			p "#{gsa_a[i].browser.title} | #{gsa_a[i].browser.url}"
			parse_mfr_list(gsa_a[i].mft_table_element.html)
		end
	end
end

# gsa_a.browser.driver.window_handles.each { |handle| gsa_a.browser.driver.switch_to.window(handle) }
#gsa_a.browser.driver.window_handles.each_index  do |i|
#	p i
# use_tab(gsa_a.browser,i)
# gsa_a.browser.windows.each_index do |i|
# gsa_a.browser.window(index: i).use do
# parse_mfr_list(gsa_a.mft_table_element.html)
#end
threads.each { |thr| thr.join }
letters.each {|l| set_mfr_list_time(l)}
# "https://www.gsaadvantage.gov/advantage/s/search.do?q=1:4*&s=4&c=100&q=28:5#{href_mfr}"






