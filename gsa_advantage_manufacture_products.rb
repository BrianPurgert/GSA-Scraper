require_relative 'gsa_advantage'

@reading    = 0
@db_queue      = Queue.new
@mfr_queue  = Queue.new
threads     = []

n_thr     = 2
n_total   = 6
get_mfr(n_total).each {|mfr| @mfr_queue << mfr}
gsa_a     = []

threads << Thread.new do
	while @reading < 10 do
		until @db_queue.empty?
			# mfr_parts_data = @db_queue.shift
			# insert_mfr_parts(mfr_parts_data)
			# mfr_time(@queue.shift)
			@reading = 0
		end
		@reading += 1
		sleep 10
	end
	# letters.each {|l| set_mfr_list_time(l)}
end


def get_parent(mpn, mfr)
	pr = mpn.parent
	puts pr.element.text
	c = 0
	until pr.text.include? mfr || c == 4
		pr = pr.parent
	end
	puts pr.html
	pr.scroll_into_view
	pr.highlight
	return [pr]
end

n_thr.times do |n|
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
			url         = search_url(mfr_href, n_low)
			gsa_a[n].browser.goto url
			title       = gsa_a[n].browser.title
			url         = gsa_a[n].browser.url
			links       = gsa_a[n].product_link_elements
			results     = gsa_a[n].browser.tables(css: "#pagination~ table:not(#pagination2)")
			n_results   = links.length
			# TODO trigger refresh if needed... gsa_a[n].browser.refresh

			case n_results
				when 0
					raise "Missing results #{gsa_a[n].browser.url}"
				when 1..100
					results.each do |container|
						result_set = []
						# Product link
						container.link(css:"a.arial[href*='product_detail.do?gsin']").href
						# Product name
						container.link(css:"a.arial[href*='product_detail.do?gsin']").text
						# manufacture part number 70006459310

						# short description

						# Mfr

						# product image href

						#.flash(color: "rgba(255, 0, 0, 0.6)",flashes: 1, persist: TRUE)


					end

					 gsa_a[n].product_link_elements.each_with_index do |link|
						 link.flash(color: "rgba(255, 0, 0, 0.6)",flashes: 1, persist: TRUE)
						      map_product
						      @db_queue  << [url, mfr_name, link.href]
					end
					last_price = gsa_a[n].ms_low_price_elements.last.text
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

	end
		end
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




















