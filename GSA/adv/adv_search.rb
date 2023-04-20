require_relative 'gsa_advantage'
include ADV

@reading   = 0
@items     = 0
@throttle  = 0
@db_queue  = Queue.new
@search_queue = Queue.new

@manufacture_search_index = 0

threads = []
n_thr   = 50
gsa_a   = []

puts 'Creating table search_list for crawl'

# manufacture q=28:5
# contract    q=19:2
# contractor  q=24:2
# category    q=1:4


def manufacture_search
  @search_in = 'q=28:5'
DB_CONNECT.create_table!(:manufacture_search, :as => DB_CONNECT[:manufactures].select(:href_name).distinct(:href_name))
DB_CONNECT[:manufacture_search].print
DB_CONNECT[:manufacture_search].each { |mfr| @search_queue << mfr[:href_name] }
end

def category_search
  @search_in = 'q=1:4'
  DB_CONNECT.create_table!(:category_search, :as => DB_CONNECT[:categories].select(:id).distinct(:id))
  DB_CONNECT[:category_search].print
  DB_CONNECT[:category_search].each { |category| @search_queue << category[:id] }
end

category_search


def get_all_products(mfr, n_low, pg)
	begin
		url            = search_url(mfr, n_low)
		html           = send_agent(url)
		doc            = Nokogiri::HTML(html)
		pagination     = doc.css('#pagination')
		next_page      = pagination.text.include? 'Next Page >'
		product_tables = doc.search('#pagination~ table:not(#pagination2)')
		n_results      = product_tables.length

    color_p "#{n_results}   #{url}"
		@items         += n_results
		      product_tables.each_with_index do |product_table, i|
			    n_low = follow_result(product_table, mfr)

			end
			pg = pg + 1
		sleep @throttle
	end while next_page
end


def controller
	@throttle = DB_CONNECT[:controller].filter(key: 'throttle').select(:value).first
	sleep 10
end


# def add_manufactures(n_total)
# 	manufactures = get_search(n_total)
# 	manufactures.each do |mfr|
# 		@mfr_queue << mfr
# 	end
# end

@continue = continue
exit unless @continue

def search
	i = 0
	while @continue
		until @search_queue.empty?
			i   += 1
			mfr = @search_queue.shift
			 puts "Start: #{mfr}"
			get_all_products(mfr, 900000000, 1)


    end
    sleep 10
		color_p 'Queue is Empty'
	end
end


# threads << Thread.new do
# 	while @continue do
# 		if @mfr_queue.size < (n_thr*2)
# 			add_manufactures(n_thr*6)
# 		end
#
# 	end
# end

threads << Thread.new do
	while @continue do
		color_p "DB Queue #{@db_queue.size}", 12
		if @db_queue.size < 1000
			sleep 10
    end
    insert_mfr_parts(take(@db_queue))
	
	end
	insert_mfr_parts(take(@db_queue))
end


# Threads to start Crawler Agents
n_thr.times do
  sleep 0.01
  threads << Thread.new do
    initialize_agent
    search
  end
end

threads.each { |thr| thr.join }
display_statistics

gsa_a.each do |b|
	begin
		b.close
	rescue
		color_p 'Browser already closed'
	end
end

















