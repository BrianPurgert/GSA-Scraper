require_relative 'report_helper'
include ReportHelper
require 'find'
require 'pp'
ENV['SEARCH_PATH']         = 'M:\GOVCON\HG'

require_relative 'import'
require_relative 'export'

# Dir["#{}*.xls"].each { |file| puts file }

# files     = Dir.glob(basedir+"*.xlsx")
# files     = Dir[basedir+"*.xlsx","*.csv","*.csv"]
# puts files.inspect
# csv_files = Dir.glob(basedir+"*.csv")
# xls_files = Dir.glob(basedir+"*.xls")
# puts Dir.entries(basedir).inspect
# @tables = []

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

import_spreadsheets(xlsx_sheets)

# deduplicate_table(DB,:IPROD,[:CONTNUM, :MFGPART, :MFGNAME])

export_price_comparisons(files)









