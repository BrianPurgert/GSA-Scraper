require_relative 'gsa_advantage'

class AdvSearch
	# @param [String] url
	def initialize(url)
		@url  = url
		@path = url.gsub
	end
end

@reading   = 0
@items     = 0
@throttle  = 2
@db_queue  = Queue.new
@mfr_queue = Queue.new

threads = []
n_thr   = 50
gsa_a   = []


# deduplicate_table(DB,:manufacture_parts,:href_name)

def get_all_products(gsa_a, mfr, n, n_low, pg, search_in)
	begin
		# url encode mfr[:name] mfr[:href_name]
		url  = search_url(mfr[:href_name], n_low, mfr[:category])
		html = get_html(gsa_a, n, url)
		doc            = Nokogiri::HTML(html)
		pagination     = doc.css("#pagination")
		next_page      = pagination.text.include? "Next Page >"
		product_tables = doc.search('#pagination~ table:not(#pagination2)')
		n_results      = product_tables.length
		@items         += n_results
		      product_tables.each_with_index do |product_table, i|
			    n_low = parse_result(product_table)
			end
			pg = pg + 1
		sleep @throttle
	end while next_page
end


def controller
	@throttle = DB[:controller].filter(key: 'throttle').select(:value).first
	sleep 20
end


def add_manufactures(n_total)
	manufactures = get_search(n_total)
	manufactures.each do |mfr|
		@mfr_queue << mfr
	end
end

@continue = continue
exit unless @continue

def search(gsa_a, n)
	i = 0
	while @continue
		until @mfr_queue.empty?
			i   += 1
			mfr = @mfr_queue.shift
			# puts "Start: #{mfr[:name]} #{mfr[:category]}"
			search_by = "contract"
			get_all_products(gsa_a, mfr, n, 900000000, 1, search_by)
			# search by contractor
			
			# puts "Finished: #{mfr[:name]} #{mfr[:category]}"
			unless MECHANIZED
				gsa_a[n] = restart_browser gsa_a[n] if i % 5 == 0
			end
		end
		puts "Queue is Empty"
	end
end


threads << Thread.new do
	while @continue do
		if @mfr_queue.size < (n_thr*2)
			add_manufactures(n_thr*6)
		end
		sleep 1 # TODO hard coded sleep
	end
end

threads << Thread.new do
	while @continue do
		color_p "DB Queue #{@db_queue.size}", 12
		if @db_queue.size > 3000
			insert_mfr_parts(take(@db_queue))
		else
			sleep 1
		end
	
	end
	insert_mfr_parts(take(@db_queue))
end

n_thr.times do |n|
	threads << Thread.new do
		gsa_a[n] = initialize_browser
		search(gsa_a, n)
	end
end

threads.each { |thr| thr.join }
display_statistics

gsa_a.each do |b|
	begin
		b.close
	rescue
		puts 'Browser already closed'
	end
end

















