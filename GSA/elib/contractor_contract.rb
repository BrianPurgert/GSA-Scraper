	require 'yaml'
	require 'axlsx'
	require 'nokogiri'
	require 'open-uri'
  require_relative '../adv/gsa_advantage'
  require_relative 'elib_parse'
  include ADV
  require 'pp'
  require 'colorize'

	@contractor_queue = Queue.new

  # sinDetails.do?scheduleNumber=84&specialItemNumber=567+4&executeQuery=YES
  # advRedirect.do?contract=GS-07F-0027M&sin=567+4&src=elib&app=cat
  # specialItemNumber=567+4
  # scheduleSummary.do?scheduleNumber=84
  # contractorInfo.do?contractNumber=GS-07F-0027M&contractorName=AERIAL+MACHINE+%26+TOOL+CORP&executeQuery=NO
  # contractorInfo.do?contractNumber=V797P-4383B&contractorName=AESYNT+INCORPORATED&executeQuery=NO

	# CSS_contractor_contract   = "a[href*='contractNumber='][href*='contractorName=']"
  LOL = "#anch_12 , td+ .columntitle , #anch_13 , .columntitle+ font , table:nth-child(1) table td+ td font , tr+ tr td+ td font"
	CONTRACTOR_INFO   = "a[href*='contractorInfo.do'][href*='contractNumber='][href*='contractorName=']"

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
	color_p schedule_start
	
	@l_queue = Queue.new
	@c_queue = Queue.new
	letters = ("A".."Z").to_a
	letters.each {|l| @l_queue << l}
	
	threads = []
	agents   = []

 20.times do
   threads << Thread.new do
     initialize_browser
   end
 end


5.times do
		threads << Thread.new do
			until @l_queue.empty?
				html      = send_agent("#{ElibMain}#{ContractorList}#{@l_queue.pop}&executeQuery=YES")
				doc       = Nokogiri::HTML(html)
				contractors = doc.css(CONTRACTOR_INFO)
				contractors.each do |cont|
            href =	clean_href(cont['href'])
            contractor_url       = "#{ElibMain}#{href}"
            contractor_html      = send_agent( contractor_url)
            contractor_doc       = Nokogiri::HTML(contractor_html)
            puts contractor_doc.css('title')
            # corporation_info(contractor_doc)
            # contract_info(contractor_doc)







            contractor = {}
            contractor[:schedule]
            contractor[:sin]
            contractor[:name]
            contractor[:address]
            contractor[:contract_number]
            contractor[:phone]
            contractor[:email]
            contractor[:website]
            contractor[:price_list]
            contractor[:duns]
            contractor[:naics]

            contractor_doc.css("a").each_with_index do |a, row_number|
             puts get_queries(clean_href(a['href']))
              # puts " #{row_content.css('.columntitle').text.strip} ".colorize(:red)
              # puts "#{row_content.css('font:not(.columntitle)').text.strip}"
              # puts "#{cell_number} | #{cell_content.text.strip}"
            end

				end
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
		
	
