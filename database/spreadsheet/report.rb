require_relative './import'
require_relative './export'

basedir                     = File.join(__dir__,'test/')
files                       = Dir.glob(basedir+"*.xlsx")

# todo name tables
tables = [:client1,:client2,:client3,:client4,:client5]

@DB.tables.each { |table| puts "#{table}\t#{@DB[table].columns.inspect}".colorize(:blue) }
files.each_with_index do |file, num|
	puts "#{num}\t#{file}".colorize(:green)
end
	files.each_with_index do |file, num|
		begin
			import_products file, tables[num]
			excel tables[num]
		rescue Exception => e
			puts e.message
		end
	end


# import_products path2, :test2



#
# puts xlsx.info
# import_price_list xlsx