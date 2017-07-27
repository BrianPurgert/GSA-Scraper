	require 'yaml'
	require 'axlsx'
	require 'nokogiri'
	require 'open-uri'
	require_relative '../../adv/gsa_advantage'


	@contractor_queue = Queue.new
	
	

	# CSS_contractor_contract   = "a[href*='contractNumber='][href*='contractorName=']"
	CONTRACTOR_INFO   = "a[href*='contractorInfo.do?'][href*='contractNumber='][href*='contractorName=']"

#
  DB.run("CREATE TABLE IF NOT EXISTS ElibMain_contractor_list
	(
		contractor_name varchar(255) not null,
		contract_number varchar(255) null,
		capture_time datetime default CURRENT_TIMESTAMP not null,
		id int not null auto_increment
		primary key,
		        priority int(10) default '0' not null
	);")




	
	
	schedule_start = "#{ElibMain}#{ScheduleList}?"
	puts schedule_start
	
	@l_queue = Queue.new
	@c_queue = Queue.new
	letters = ("A".."Z").to_a
	letters.each {|l| @l_queue << l}
	
	threads = []
	agents   = []

  def upload(threads)
    threads << Thread.new do
      until @l_queue.empty? && @c_queue.empty? do
        until @c_queue.empty?
          puts @c_queue.pop
          # insert_c(take(@mfr_queue))
        end
      end
    end
  end

  upload(threads)
	
	5.times do |i|
		threads << Thread.new do
			agents[i] = initialize_browser
			until @l_queue.empty?
				letter    = @l_queue.pop
				url       = "#{ElibMain}#{ContractorList}#{letter}&executeQuery=YES"
				html      = get_html(agents, i, url)
				doc       = Nokogiri::HTML(html)
				contractors = doc.css(CONTRACTOR_INFO)
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
		
	
