require_relative '../../adv/gsa_advantage'
require 'roo'
path = "database/spreadsheet/test/Test File 1.xlsx"


xlsx = Roo::Spreadsheet.open('./test/Test File 1.xlsx')
xlsx = Roo::Excelx.new("./test/Test File 1.xlsx")

puts xlsx.info

xlsx.each_with_pagename do |name, sheet|
	p sheet.row(1)
	@DB.create_table :items do
		primary_key :id
		String :name
		Float :price
	end
	
	
	@DB.create
		sheet.each(sin: 'SIN',
		           manufacture_name:       'MFG Name',
		           manufacture_part:       'MFG Number',
		           dealer_part_number:     'Dealer Part Number',
		           product_name:           'Product Name',
		           product_description:    'Product Description',
		           gsa_price:              'GSA Price') do |hash|
		puts hash.inspect
	end
	
end


