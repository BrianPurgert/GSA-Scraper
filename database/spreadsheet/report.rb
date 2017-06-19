require_relative './import'
loop do
basedir                     = File.join(__dir__,'test/')
files                       = Dir.glob(basedir+"*.xlsx")
files.each_with_index do |file, num|
	puts "#{num}\t#{file}\t".colorize(:green)
end

begin
	import_products files[gets.to_i], :test1
rescue Exception => e
	puts e.message
end

end


# import_products path2, :test2



#
# puts xlsx.info
# import_price_list xlsx