require 'axlsx'

def view(table)
	result = DB_CONNECT[:manufacture_parts].join(table, :manufacture_part => :mpn)
	DB_CONNECT.create_view(:price_comparisons, result)
end

def compare_products(db, table)
	puts "Manufacture parts join #{table}"
	# manufacture_parts = @DB[:manufacture_parts].reverse(:last_updated).distinct(:mpn)
	manufacture_parts = db[:manufacture_parts] #.select(:, :b)
	result            = db[table].left_outer_join(manufacture_parts, :mfr => :MFGNAME, :mpn => :MFGPART)
	# result = @DB[table].left_join(:manufacture_parts,:manufacture_name => :mfr, :manufacture_part => :mpn)

	# Todo create table from that dataset
	# @DB[:table1].import([:x, :y], result.select(:a, :b))
	# DB[:table].multi_insert([{:x => 1}, {:x => 2}])
	result = result.all
	puts "Lookup Complete #{table}"
	result
end

def excel(table)
	result     = compare_products(table)
	p          = Axlsx::Package.new
	wb         = p.workbook
	styles     = wb.styles
	col_header = styles.add_style :bg_color => 'FFDFDEDF', :b => true, :alignment => { :horizontal => :center }
	wb.add_worksheet(:name => 'Overview') do |sheet|
		sheet.add_row [
		              'Manufacture Name',
		              'Manufacture Part',
		              'Product',
		              'Your Price',
		              'Lowest Price',
		              'URL',
		              'Sources',
		              'description',
		              ], style: [col_header, col_header, col_header, col_header, col_header, col_header, col_header, col_header]

		result.each do |row|
			sheet.add_row([
			              row[:manufacture_name],
			              row[:manufacture_part],
			              row[:name],
			              row[:gsa_price],
			              row[:low_price],
			              "https://gsaadvantage.gov#{row[:href_name]}",
			              row[:sources],
			              row[:desc]
			              ])
		end
		p.serialize "./export/#{table.to_s}-PCP.xlsx"
	end
end

	

	


	

