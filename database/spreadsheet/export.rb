require_relative '../../adv/gsa_advantage'
require 'axlsx'



def view(table)
	result = @DB[:manufacture_parts].join(table, :manufacture_part => :mpn)
	@DB.create_view(:price_comparisons,result)
end

def excel(table)
	puts "Manufacture parts join #{table}"
	result = @DB[:manufacture_parts].join(table, :manufacture_part => :mpn,:manufacture_name => :mfr)
	result.print
	# Todo create table from that dataset
	
	result = result.all
	p = Axlsx::Package.new
	wb = p.workbook
	styles = wb.styles
	
	    col_header = styles.add_style :bg_color => "FFDFDEDF", :b => true, :alignment => { :horizontal => :center }

            wb.add_worksheet(:name => "Overview") do |sheet|
	                  sheet.add_row ['Manufacture Part',
	                                 'Manufacture Name',
	                                 'Product',
	                                 'Lowest Price',
	                                 'Client Price',
	                                 'URL',
	                                 'sources',
	                                 'description',
	                                ], :style => [ col_header, col_header, col_header,  col_header,  col_header, col_header, col_header, col_header]
	                  
		result.each do |row|
			sheet.add_row([
			              row[:mpn],
			              row[:mfr],
			              row[:name],
			              row[:low_price],
			              row[:gsa_price],
			              row[:href_name],
					  row[:sources],
			              row[:desc]
			              ])
		end
      p.serialize "#{table.to_s}-PCP.xlsx"

  end
end

	
	# excel_file_out_name = "#{Basedir_output}#{Current_time.month}-#{Current_time.day}-#{xls_read}"
	


	

