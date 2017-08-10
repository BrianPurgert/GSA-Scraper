require 'bundler'
require 'bundler/setup'
require 'rake'
require 'colorize'
# require_relative 'config.ru'
# require_relative 'GSA/adv/adv_base'



desc 'Default Tasks'
task(default:
         [:crawl_web_manufactures_vendors_categories,
          :crawl_web_master_products,
          :crawl_web_base_products])




task(:crawl_network) do
  puts "Crawling Network for with SIP files".colorize(:yellow)
	ruby 'report/report.rb'
end


task(:crawl_web_manufactures_vendors_categories) do
	ruby 'GSA/adv/adv_base.rb'
end

task(:crawl_web_master_products) do
	ruby 'GSA/adv/adv_search.rb'
end

task(:crawl_web_base_products) do
	ruby 'GSA/adv/adv_product.rb'
end

desc 'Install Gems'
task(:install) do
	exec("cd #{Dir.getwd} && bundle update && bundle install")
end






# source_files = Rake::FileList.new("**/*.xlsx", "**/*.xls") do |fl|
#   fl.exclude("~*")
#   fl.exclude(/^scratch\//)
#   fl.exclude(/^export\//)
#   fl.exclude do |f|
#     `git ls-files #{f}`.empty?
#   end
# end
# puts source_files.pretty_inspect