require_relative '../../adv/gsa_advantage'
require 'roo'

def read_client_price_list

end

def create_database_table name
'Mfg Part number'
'MFG Name'
'Vendor Name'
'Lowest Price'
'URL'
'Client Price' # (From input table)
end

def import_price_list(spreadsheet)
spreadsheet.each_with_pagename do |name, sheet|
	p sheet.row(1)
	@DB.create_table? :items do
		primary_key :id
		String :name
		Float :price
	end
	
	data = sheet.parse(clean: true, manufacture_name: 'MFG Name')
	p data.inspect
	# header_search:
	exit
	sheet.each(
	# sin: 'SIN',
	manufacture_name:       'MFG Name',
	manufacture_part:       'MFG Number',
	# dealer_part_number:     'Dealer Part Number',
	# product_name:           'Product Name',
	# product_description:    'Product Description',
	gsa_price:              'GSA Price '
	) do |hash|
		 p hash.inspect
	end
	
end
end

path = "./test/Test File 1.xlsx"
xlsx = Roo::Spreadsheet.open(path)
xlsx = Roo::Excelx.new(path)
puts xlsx.info
import_price_list xlsx
