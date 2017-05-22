require_relative 'gsa_advantage'
RX_mfr      = /(?<=\q=28:5).*/
threads     = []
gsa_a       = []
config      = [3]
@queue      = Queue.new
@reading    = 0

ARGV.each_with_index { |a,i| config[i] = a }
letters = get_mfr_list(config[0])
# letters = ['X','Y']


threads << Thread.new do
	while @reading < 10 do
		p "Queue Length: #{@queue.length}"
		sleep 5
	end
end

threads << Thread.new do
	while @reading < 10 do
		until @queue.empty?
			next_object = @queue.shift
			insert_mfr(next_object[0],next_object[1],next_object[2])
			@reading = 0
		end
		@reading += 1
		sleep 10
	end
	letters.each {|l| set_mfr_list_time(l)}
end


letters.each_with_index do |letter, i|
	threads << Thread.new {
	gsa_a[i] = initialize_browser
	gsa_a[i].browser.goto "https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4*&listFor=#{letter}"
		# Thread.current[:name] = []
		gsa_a[i].mft_table_element.links.each do |link|
			href_mfr = RX_mfr.match(link.href)
			link.flash(color: "yellow",flashes: 1)
			# link.highlight
			name_mfr = link.text
			e_products = link.parent.following_sibling
			e_products.flash(color: "yellow",flashes: 1)
			n_products = e_products.text
			n_products = n_products.delete('()')
			@queue << [name_mfr,href_mfr,n_products]
		end
		
	}
end

threads.each { |thr| thr.join }
#  next step load the parts
# "https://www.gsaadvantage.gov/advantage/s/search.do?q=1:4*&s=4&c=100&q=28:5#{href_mfr}"






