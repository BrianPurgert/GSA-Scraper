require 'yaml'

require 'axlsx'
require 'nokogiri'
require 'open-uri'
require 'net_http_ssl_fix'
# require 'open_uri_redirections'

# https://inventory.data.gov/dataset/4fd4a79f-7fd6-4699-a77a-411bc7e980b9/resource/bfd33f01-4156-44a9-a680-d31dc42a857c/download/elibraryschedulecontracts.xlsx

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
@Elibq = Queue.new

ElibMain       = "https://www.gsaelibrary.gsa.gov/ElibMain/"
ContractorList = "contractorList.do?contractorListFor="
MfrList        = "mfrList.do?scheduleNumber=84&searchMethod=autonomy"
Manufacturer   = "manufacturer.do?mfrName=3M+Company"
CSS_contract   = "a[href*='contract=']"
CSS_table      = "td td td+ td"



CSV.open("contractor_data.csv", "wb") do |csv|

end

p          = Axlsx::Package.new
wb         = p.workbook
wb.add_worksheet(name: "Contract End Dates") do |sheet|
	
	sheet.add_row ["Contractors"]
	sheet.add_row ["Company", "Contract End Date", "Source", "Email"]
	
	("A".."Z").each_with_index do |letter, index|
		url = "#{ElibMain}#{ContractorList}#{letter}"
		@page_links = []
		
		doc = Nokogiri::HTML(open(url))
		contractors = doc.css("a[href*='contractorInfo.do']")
		contractors.map! { |contractor| @page_links << contractor['href'] }
	
		threads = []
		

		# mcsv.to_csv(@page_links)
		@page_links.each_with_index do |contractor_information, link_index|
			threads << Thread.new do
			
			url = "#{ElibMain}#{contractor_information}"
			doc = Nokogiri::HTML(open(url))
			inner = doc.css(CSS_table)
			inner.each { |td| print "#{td.text}" }
			
		end
		end
	end
threads.each { |thr| thr.join }
	# p.serialize("Contractor_Experation_dates.xlsx")
end