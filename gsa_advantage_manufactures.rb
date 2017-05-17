require_relative 'gsa_advantage'

N_threads = 10
N_threads_plus_one = N_threads+1
@browser_threads = (0..N_threads)
browser       = []
gsa_advantage = []
RX_mfr = /(?<=\q=28:5).*/
gsa_a = []
mfr_list = ("A".."F").to_a << "0"
mfr_list = ("A".."C").to_a

threads = []
@queue = Queue.new
@reading = true
letters = get_mfr_list(5)
p letters.inspect

threads << Thread.new do
	while @reading do
	until @queue.empty?
		# This will remove the first object from @queue
		next_object = @queue.shift
		insert_mfr(next_object[0],next_object[1],next_object[2])
	end
		p '------------  queue empty'
		sleep 5
	end
end


letters.each_with_index do |letter, i|
	threads << Thread.new {
	gsa_a[i] = initialize_browser
	gsa_a[i].browser.goto "https://www.gsaadvantage.gov/advantage/s/mfr.do?q=1:4*&listFor=#{letter}"
		mfrs = []
		href_mfrs = []
		Thread.current[:name] = []
		gsa_a[i].mft_table_element.links.each do |link|
			href_mfr = RX_mfr.match(link.href)
			name_mfr = link.text
			n_products = link.parent.following_sibling.text
			n_products = n_products.delete('()')
			@queue << [name_mfr,href_mfr,n_products]
			# insert_mfr(name_mfr,href_mfr,n_products)
			# @href_mfrs << @href_mfr
			# puts @href_mfr
		end

	}


end

threads.each { |thr| thr.join }
#  next step load the parts
# "https://www.gsaadvantage.gov/advantage/s/search.do?q=1:4*&s=4&c=100&q=28:5#{href_mfr}"






