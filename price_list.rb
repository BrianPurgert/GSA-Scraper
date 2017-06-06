require 'spreadsheet'

def xls_read
     Spreadsheet.client_encoding = 'UTF-8'
     puts "\nInput file number & press enter"
     Files_input.each_with_index do |file, num| puts "#{num}\t#{file}\t".colorize(:green)
     end
	pick_num   = gets.to_i
     # pick_num             = 0
     user_excel_file_name = Dir.entries(Basedir_input)
     user_excel_file_name = user_excel_file_name[2]
     puts user_excel_file_name
     book        = Spreadsheet.open Files_input[pick_num]
     sheet       = book.worksheet 0
     @mfr_found  = false
     @mfrn_found = false
     sheet.each_with_index do |row, r_index| if @mfr_found == true && !row[@mfr_col].nil?
                                                  @href_name << row[@mfr_col].to_s
                                             end
     if @mfrn_found == true && !row[@mfrn_col].nil?
          @mfr_name << row[@mfrn_col].to_s
     end
     row.each_with_index do |col, c_index| cell = col.to_s.downcase
     if cell.include?('mfr part') || cell.include?('mfgpart') || cell.include?('manufacturer part') || cell.include?('mpn') || cell.include?('mfg part')
          @mfr_col   = c_index
          @mfr_row   = r_index
          @mfr_found = true
          puts "\nManufacture Part Number Found at:\t#{@mfr_col} #{@mfr_row}\n"
     end
     if cell.include?('mfr name') || cell.include?('mfg number') || cell.include?('manufacturer name') || (cell.include?('mfr') && !cell.include?('part')) || (cell.include?('manufacture') && !cell.include?('part'))
          @mfrn_col   = c_index
          @mfrn_row   = r_index
          @mfrn_found = true
          puts "\nManufacture Found at:\t#{@mfrn_col} #{@mfrn_row}\n"
     end
     end
     end
     puts @mfrn_found ? "Manufacture found".colorize(:green) : "Manufacture not found".colorize(:red)
     exit if !@mfrn_found
     return user_excel_file_name
end