require_relative 'gsa_advantage'

@reading    = 0
@queue      = Queue.new
@mfr_queue  = Queue.new
threads     = []

n_thr     = 16
n_total   = 50


get_mfr(n_total).each {|mfr| @mfr_queue << mfr}
gsa_a     = []

def get_parent(mpn, mfr)
	pr = mpn.parent
	puts pr.element.text
	c = 0
	until pr.text.include? mfr || c == 4
		pr = pr.parent
	end
	puts pr.html
	pr.scroll_into_view
	pr.flash
	return [pr]
end

(0...n_thr).each_with_index do |n|
	threads << Thread.new do
	gsa_a[n] = initialize_browser
	until @mfr_queue.empty?
		mfr = @mfr_queue.shift
		p mfr.inspect
		# puts "Search Start:\t#{mfr['name']}    gsa_advantage:\t#{gsa_advantage[n]}"
		mfr_name       = mfr[:name]
		mfr_href       = mfr[:href_name]
		mfr_item_count = mfr[:item_count]
		pg             = 1
		n_low          = 900000000
		begin
			url = search_url(mfr_href, n_low, 1)
			gsa_a[n].browser.goto url
			#TODO browser.wait stops script
			# gsa_a[n].browser.wait
			n_results = gsa_a[n].product_link_elements.length
			if n_results == 0
				gsa_a[n].browser.refresh
				n_results = gsa_a[n].product_link_elements.length
			end
			title     = gsa_a[n].browser.title
			url       = gsa_a[n].browser.url

			result    = []
			case n_results
				when 0
					puts "No Results on #{gsa_a[n].browser.url}"
				when 1..100
					text   = gsa_a[n].main_alt
					html   = gsa_a[n].main_alt_element.html

					# gsa_a[n].product_link_elements.each_with_index do |link,i|
					#      result  << [url, mfr_name, link.href]
					# end
					last_price = gsa_a[n].ms_low_price_elements[-1].text
					n_low  = last_price[1..-1].tap { |s| s.delete!(',') }
					# $49,127,529.41
					# puts n_low
					f_name = "#{mfr_href}-#{pg}"
					save_page(html, gsa_a[n].browser.url, text, f_name)
					pg = pg + 1
					color_p "#{n}\t|#{f_name} |\t #{title} |#{n_low}\n#{url[30..-10]}",n
				# puts n_low
				else
					puts "error in number of results on page, n_results: #{n_results}"
			end
		end while n_results == 100
		@queue << mfr_name
	end
		end
end


threads << Thread.new do
	while @reading < 10 do
		until @queue.empty?
			print "\r #{@queue.size}"
			mfr_time(@queue.shift)
		end
		@reading += 1
		sleep 5
	end
	puts 'I guess it is done'
end

threads.each { |thr| thr.join }


# initialize_browsers()
# (0..3).each do |index|
# 	puts "Companies Processed: #{index}".colorize(:red)
# 	search_on_browser(1, get_mfr)
# end

# @semaphore = Mutex.new
#  @threads = []
#  t_count = 0;
# (0..2000).each do |index|
#      thr_n = index % N_threads_plus_one
#       puts "thr_n #{thr_n}"
#  	    t_count = t_count+1
#  	    @threads << Thread.new do
#  		    search_on_browser(thr_n, get_mfr)
#  	    end
#      if t_count >= N_threads
#  	    @threads.each { |t| t.join if t != Thread.current }
#  	    t_count = 0
#      end
#  end
#  Thread.list.each { |t| t.join if t != Thread.current }




















