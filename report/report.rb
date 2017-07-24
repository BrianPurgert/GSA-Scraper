require_relative 'report_helper'
include ReportHelper
require 'find'
require 'pp'
ENV['SEARCH_PATH']         = "Z:\\Gold Clients Archive"
ENV['SEARCH_PATH']         = "X:\\"

require_relative 'import'
require_relative 'export'

 # Dir["#{}*.xls"].each { |file| puts file }




xls_sheets = []
xlsx_sheets = []
csv_sheets = []
Find.find(ENV['SEARCH_PATH']) do |path|
	csv_sheets << path if path =~ /.*\.csv$/
	xls_sheets << path if path =~ /.*\.xls$/
	xlsx_sheets << path if path =~ /.*\.xlsx$/
end

list_files(csv_sheets)
list_files(xls_sheets)
list_files(xlsx_sheets)
import_spreadsheets(xls_sheets)
import_spreadsheets(xlsx_sheets)

# deduplicate_table(DB,:IPROD,[:CONTNUM, :MFGPART, :MFGNAME])

export_price_comparisons(xlsx_sheets)









