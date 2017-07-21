require_relative 'gsa_advantage'
1.times do



	
	
threads     = []
gsa_a       = []
config      = [6]

@vnd_queue      = Queue.new
@mfr_queue      = Queue.new
@letter_queue = Queue.new
# @reading    = 0

ARGV.each_with_index { |a,i| config[i] = a }
letters = ("A".."Z").to_a << '0'
letters.each {|l| @letter_queue << l}


threads << Thread.new do
	until @letter_queue.empty? && @mfr_queue.empty? && @vnd_queue.empty? do
		until @mfr_queue.empty?
			insert_manufactures(take(@mfr_queue))
		end
		until @vnd_queue.empty?
			insert_contractors(take(@vnd_queue))
		end

		sleep 1
	end
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
found = 0
benchmark '', @count

	27.times do |i|
	threads << Thread.new do
		gsa_a[i] = initialize_browser
		until @letter_queue.empty?
				letter = @letter_queue.pop
			ADV::Lists.each do |list|
				ADV::Categories.each do |category|
					url = "https://www.gsaadvantage.gov/advantage/s/#{list}q=1:4#{category}*&listFor=#{letter}"
					html = get_html(gsa_a, i, url)
					found = parse_list(html, list, category)
					sleep 2
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




