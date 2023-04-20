
require_relative '../GSA/adv/gsa_advantage'
include ADV
require 'roo'
require 'prettyprint'
require 'pp'
require 'roo-xls'
require 'colorize'
require 'find'
require_relative 'report_helper'
require_relative 'import'
require_relative 'export'

THREADS = []


 # Dir["#{}*.xls"].each { |file| puts file }
abc = ('A'..'Z').to_a
xls_other   = []
xlsx_sheets = []
csv_sheets  = []

abc.each do |xyz|
  # sleep 1
  # THREADS << Thread.new do

  begin
  Find.find("#{xyz}:\\") do |path|
    if path =~ /.*\.xls$/
      case
        when path.include?('IACCXPRO')     then     import(path,:IACCXPRO)
        when path.include?('IBPA')         then     import(path,:IBPA)
        when path.include?('ICOLORS')      then     import(path,:ICOLORS)
        when path.include?('ICONTR')       then     import(path,:ICONTR)
        when path.include?('ICORPET')      then     import(path,:ICORPET)
        when path.include?('IFABRICS')     then     import(path,:IFABRICS)
        when path.include?('IMOLS')        then     import(path,:IMOLS)
        when path.include?('IMSG')         then     import(path,:IMSG)
        when path.include?('IOPTIONS')     then     import(path,:IOPTIONS)
        when path.include?('IPHOTO')       then     import(path,:IPHOTO)
        when path.include?('IPRICE')       then     import(path,:IPRICE)
        when path.include?('IPROD')        then     import(path,:IPROD)
        when path.include?('IQTYVOL')      then     import(path,:IQTYVOL)
        when path.include?('IREMITOR')     then     import(path,:IREMITOR)
        when path.include?('ISPECTER')     then     import(path,:ISPECTER)
        when path.include?('IZONE')        then     import(path,:IZONE)
        else
          color_p "#{path}", 14
          xls_other << path
      end

    elsif path =~ /.*\.xlsx$/
      color_p "#{path}", 15
      xlsx_sheets << path
    else

    end

  end
  rescue
    puts "No Drive: #{xyz}"
  end

  end
# end
# THREADS.each { |thr| thr.join }

exit
deduplicate_schedule_tables(DB_CONNECT)


list_files(xls_other)
# list_files(xlsx_sheets)
import_spreadsheets(xls_other)
# import_spreadsheets(xlsx_sheets)

# deduplicate_table(DB,:IPROD,[:CONTNUM, :MFGPART, :MFGNAME])

# export_price_comparisons(xlsx_sheets)









