



  Header_MFR      = /(MFG|MFR|Manufacture|Manufacturer)*Name/ix
  Header_PART     = /(MFG|MFR|Manufacture|Manufacturer)*(Number|Part)/ix
  Header_PRICE    = /(.*)GSAPRICE(.*)/ix
  SCHEDULE_HEADER = /(VENDNAME|CONTNUM)/ix


  def import(path, table)
    begin
            open_file = open_excel(path)
            unless open_file.nil?
              sheet_data = open_file.parse(clean: true, header_search: [SCHEDULE_HEADER])
              DB[table].multi_insert(sheet_data)
            end
    rescue Exception => ex
      puts ex.message
    end


  end
    # puts sheet_data.pretty_inspect
    # DB[:IPROD].multi_insert(sheet_data)
    # columns = DB[table].columns.to_a
    # DB[table].import(columns, sheet_data)


  def open_excel(path)
    file_name = Pathname.new(path).basename
    unless path.include? '~'
      begin
        open_file = Roo::Spreadsheet.open(path, extension: :xlsx)
      rescue
        open_file = Roo::Spreadsheet.open(path, extension: :xls)
      rescue Exception => exception
        puts exception
      end
      puts "#{open_file.info}".colorize(:yellow)
    end
    open_file
  end

  def list_files(files)
		files.each_with_index do |file, num|
			puts "#{num}\t#{file}"
		end
	end
	
	def import_spreadsheets(files)
		puts "Import Spreadsheets? (Y/N)"
		if gets.to_s.upcase.include? 'Y'
			puts "#{files.size} files importing"
			# threads = []
			files.each_with_index do |file|
				 # threads << Thread.new {
						import(file,:client_data)
				 # }
			end
			 # threads.each { |thr| thr.join }
			puts "Imports Complete"
		end
	end


	
	def export_price_comparisons(files)
		puts "Generate Price Comparisons? (Y/N)"
		if gets.to_s.upcase.include? 'Y'
			excel :iprod
			# threads = []
			# files.each_with_index do |file, num|
			# 	threads << Thread.new { excel tables[num] }
			# end
			# threads.each { |thr| thr.join }
		end
	end



