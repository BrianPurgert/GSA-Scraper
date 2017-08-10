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


     return user_excel_file_name
end