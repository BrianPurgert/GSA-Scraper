require_relative 'report_helper'
include ReportHelper
require 'find'
require 'pp'
ENV['SEARCH_PATH']         = "Z:\\Gold Clients Archive"


require_relative 'import'
require_relative 'export'

 # Dir["#{}*.xls"].each { |file| puts file }




xls_sheets = []
xlsx_sheets = []
csv_sheets = []
Find.find(ENV['SEARCH_PATH']) do |path|

  if path =~ /.*\.xls$/
    xls_sheets << path
  end

  if path =~ /.*\.xlsx$/
    xlsx_sheets << path
  end

end

list_files(xls_sheets)
list_files(xlsx_sheets)
import_spreadsheets(xls_sheets)
import_spreadsheets(xlsx_sheets)

# deduplicate_table(DB,:IPROD,[:CONTNUM, :MFGPART, :MFGNAME])

export_price_comparisons(xlsx_sheets)









