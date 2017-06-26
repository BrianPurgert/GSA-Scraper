require 'page-object'
require 'watir'
require 'yaml'
require 'page-object/page_factory'
require_relative 'features/support/gsaelibrary_page'
require 'axlsx'
require 'nokogiri'
require 'open-uri'
require 'net_http_ssl_fix'
# require 'open_uri_redirections'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'fastercsv'
ElibMain       = "https://www.gsaelibrary.gsa.gov/ElibMain/"
ContractorList = "contractorList.do?contractorListFor="
MfrList        = "mfrList.do?scheduleNumber=84&searchMethod=autonomy"
Manufacturer   = "manufacturer.do?mfrName=3M+Company"
# advRedirect.do?contract=GS-21F-0075X&sin=105+002&src=elib&app=cat
# advRedirect.do?contract=GS-07F-0039V&mfrName=3M&src=elib&app=cat

mcsv       = FCSV.new
#CSV.open("contractor_data.csv", "wb") do |csv|


p          = Axlsx::Package.new
wb         = p.workbook
wb.add_worksheet(name: "Contract End Dates") do |sheet|
	
	sheet.add_row ["Contractors"]
	sheet.add_row ["Company", "Contract End Date", "Source", "Email"]

	("A".."B").each_with_index do |letter, index|
		url = "#{ElibMain}#{ContractorList}#{letter}"
		@page_links = []
		
		doc = Nokogiri::HTML(open(url))
		contractors = doc.css("a[href*='contractorInfo.do']")
		contractors.each { |contractor| @page_links << contractor['href'] }
		
		puts @page_links
	
		

		# mcsv.to_csv(@page_links)
		@page_links.each_with_index do |contractor_information, link_index|
			url = "#{ElibMain}#{contractor_information}"
			doc = Nokogiri::HTML(open(url))
			begin
				doc.css("a[href*='contract=']").each_with_index { |catalog, i| sheet.add_row [catalog['href']] }
				
			rescue
				puts 'element not found '
			end
		end
	end
	p.serialize("Contractor_Experation_dates.xlsx")
end