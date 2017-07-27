require_relative 'gsa_advantage'

	
threads     = []
gsa_a       = []


@vnd_queue      = Queue.new
@mfr_queue      = Queue.new
@database_queue = Queue.new
@alphabet_queue = Queue.new


letters = ("A".."Z").to_a << '0'
letters.each {|l| @alphabet_queue << l}


threads << Thread.new do
	until @alphabet_queue.empty? && @mfr_queue.empty? && @vnd_queue.empty? && @database_queue.empty? do
		until @mfr_queue.empty?
			insert_manufactures(take(@mfr_queue))
		end
		until @vnd_queue.empty?
			insert_contractors(take(@vnd_queue))
		end
		until @database_queue.empty?
			insert_elib_contractors(take(@database_queue))
		end


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
benchmark '', @count

	27.times do |i|
	threads << Thread.new do
		gsa_a[i] = initialize_browser
		until @alphabet_queue.empty?
				letter = @alphabet_queue.pop
        # parse
			  # todo	eli = "https://www.gsaelibrary.gsa.gov/ElibMain/contractorList.do?contractorListFor=#{letter}"
			ADV::Lists.each do |list|
				ADV::Categories.each do |category|
					url = "https://www.gsaadvantage.gov/advantage/s/#{list}q=1:4#{category}*&listFor=#{letter}"
					html = get_html(gsa_a, i, url)
					parse_list(html, list, category)

				end
			end
		end
	end
end

threads.each { |thr| thr.join }

end




