require_relative 'gsa_advantage'

n_url_thr = 3
n_thr = 6
n_total = n_thr*n_url_thr
page_urls = get_mfr(n_total)
mfr_set   = page_urls.each_slice(n_url_thr).to_a
gsa_a = []

def get_parent(mpn,mfr)
	pr = mpn.parent
	puts pr.element.text
	c  = 0
	until pr.text.include? mfr || c == 4
	     pr = pr.parent
	end
	puts pr.html
	pr.scroll_into_view
     pr.flash
	return [pr]
end

mfr_set.in_threads(n_thr).each_with_index do |mfrs, n|

	gsa_a[n] = initialize_browser
	mfrs.each do |mfr|
		p mfr.inspect
     	# puts "Search Start:\t#{mfr['name']}    gsa_advantage:\t#{@gsa_advantage[n]}"
	mfr_name       = mfr[:name]
	mfr_href       = mfr[:href_name]
	mfr_item_count = mfr[:item_count]
	pg = 1
      n_low                  = 900000000
	begin
		gsa_a[n].browser.goto search_url(mfr_href, n_low, 1)
		gsa_a[n].browser.wait
		title = gsa_a[n].browser.title
		url = gsa_a[n].browser.url
		n_results = gsa_a[n].product_link_elements.length
		result = []
          case n_results
               when 0
                    puts "No Results on #{gsa_a[n].browser.url}"
	          when 1..100
		          text = gsa_a[n].main_alt
		          html = gsa_a[n].main_alt_element.html

			     # gsa_a[n].product_link_elements.each_with_index do |link,i|
				#      result  << [url, mfr_name, link.href]
			     # end
                        n_low = gsa_a[n].ms_low_price_elements[-1].text.scan(/\d+/).first
		            f_name = "#{mfr_href}-#{pg}"
		            save_page(html, gsa_a[n].browser.url, text,f_name)
		            pg = pg + 1
		            color_p "#{n}|#{f_name} | #{title}",n
                         # insert_result_block(result)
			    # puts n_low
	          else
				puts "error in number of results on page, n_results: #{n_results}"
		end
	end while n_results == 100
	mfr_time(mfr_name)
		end
	end


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




















