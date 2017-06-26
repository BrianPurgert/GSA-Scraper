require 'rubygems'
require 'restclient'

require 'nokogiri'
require 'fileutils'

require_relative '../samples/fecimg-module'


HOST_URL = 'http://query.nictusa.com'
term = "obama"
links_limit = 5

puts "Starting scrape for committees that match `#{term}`"
results_committee_listing = FECImages.search(term)


#######   Save the results listing for `term`
results_local_dir = "data-hold/#{term}"
FileUtils.makedirs(results_local_dir)
File.open("#{results_local_dir}/committees_listing.html", 'w'){|f| f.write(results_committee_listing['page'])}

results_committee_listing['links'].to_a.shuffle.first(links_limit).each do |committee_link|
	c_name = committee_link.text
	c_href = "#{HOST_URL}#{committee_link['href']}"
	
	puts "Retrieving filings for committee: #{c_name}"
	if results_filings_listing = FECImages.get_filings_list(c_href)
		puts "#{results_filings_listing['links'].length} filings found"
		
		#######  Save the filings listing for `c_name`
		filings_listing_dir = "#{results_local_dir}/#{c_name}"
		FileUtils.makedirs(filings_listing_dir)
		File.open("#{filings_listing_dir}/filings_listing.html", 'w'){|f| f.write(results_filings_listing['page'])}
		
		#######  Now get all the PDFs
		
		results_filings_listing['links'].to_a.shuffle.first(links_limit).each do |pdf_link|
			
			# get the filing id: this regex should always work if the link is of correct format
			pdf_href = "#{HOST_URL}#{pdf_link['href']}"
			f_id = pdf_link['href'].split('/')[-1].match(/(\w+)(?:\.pdf)?/i)[1]
			
			puts "Retrieving PDF at #{pdf_href}"
			sleep(1.0 + rand)
			
			#######  Save PDF
			if pdf_file = FECImages.get_filing_pdf(pdf_href)
				File.open("#{filings_listing_dir}/#{f_id}.pdf", 'w'){|f| f.write(pdf_file)}
			else
				puts "* FAILED to get filing #{f_id}"
			end
		end
	
	
	else # get_filings_list failed
		puts "* FAILED to get filings for committee: #{c_name}"
	end
end