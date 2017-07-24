	require 'yaml'
	require 'axlsx'
	require 'nokogiri'
	require 'open-uri'
	require_relative '../../adv/gsa_advantage'



	@Elibq = Queue.new
	
	

	# CSS_contractor_contract   = "a[href*='contractNumber='][href*='contractorName=']"
	CSS_contractor_contract   = "a[href*='contractorInfo.do?'][href*='contractNumber='][href*='contractorName=']"

	
	# DB.create_table?(:albums_tags) do
	# 	foreign_key :album_id, :albums
	# 	foreign_key :tag_id, :tags
	# 	primary_key [:album_id, :tag_id]
	# end
	DB.create_table? :contractors do
		primary_key :id
		String :contract_number
		String :contractor_name
	end
	#
	# DB.run("CREATE TABLE contractor(
	# 	contractor VARCHAR(35) PRIMARY KEY NOT NULL,
	# 	contract VARCHAR(12) NOT NULL);
	# CREATE UNIQUE INDEX contractor_contractor_uindex ON contractor (contractor)")
	
	
	# DB.create_table?(:contractor) do
	#
	#
	# 	column :CONTNUM      ,String,           size: 12               ,null: false
	# 	column :MFGPART      ,String,           size: 40               ,null: false
	# 	scheduleNumber
	# 	column :SCHEDCAT     ,String,           size: 10
	# 	column :VENDNAME     ,String,           size: 35
	# 	column :GSIN          ,String,           size: 15              ,null: false
	#
	# 	column :MFGNAME      ,String,           size: 40               ,null: false
	# 	column :SCHEDCAT     ,String,           size: 10
	# 	column :VENDNAME     ,String,           size: 35
	# 	column :SIN          ,String,           size: 15              ,null: false
	# end
	
	
	schedule_start = "#{ElibMain}#{ScheduleList}"
	puts schedule_start
	
	threads = []
	gsa_a   = []
	@l_queue = Queue.new
	@c_queue = Queue.new
	letters = ("A".."Z").to_a
	letters.each {|l| @l_queue << l}
	
	threads = []
	gsa_a   = []
	
	threads << Thread.new do
		until @l_queue.empty? && @c_queue.empty?  do
			until @c_queue.empty?
				puts @c_queue.pop
				 insert_c(take(@mfr_queue))
			end
		end
	end
	
	5.times do |i|
		threads << Thread.new do
			gsa_a[i] = initialize_browser
			until @l_queue.empty?
				letter    = @l_queue.pop
				url       = "#{ElibMain}#{ContractorList}#{letter}"
				html      = get_html(gsa_a, i, url)
				doc       = Nokogiri::HTML(html)
				contractors = doc.css(CSS_contractor_contract)
				contractors.each { |cont| puts cont['href'] }
			# contractors.map! { |contractor| @c_queue << contractor['href'] }
				end
				
			end
		end
		
		

			# mcsv.to_csv(@page_links)
			# page_links.each_with_index do |contractor_information, link_index|
			# 	threads << Thread.new do
			#
			# 		url = "#{ElibMain}#{contractor_information}"
			# 		doc = Nokogiri::HTML(open(url))
			# 		inner = doc.css(CSS_table)
			# 		inner.each { |td| print "#{td.text}" }
			#
			# 	end
			# end
		
		threads.each { |thr| thr.join }
		
	
