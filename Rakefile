require 'bundler'
require 'bundler/setup'
require 'rake'

# Bundler::GemHelper.install_tasks
# Bundler::Install.options

desc 'Default Tasks'
task(default: [:s2])

# source_files = Rake::FileList.new("**/*.xlsx", "**/*.xls") do |fl|
# 	fl.exclude("~*")
# 	fl.exclude(/^scratch\//)
# 	fl.exclude(/^export\//)
# 	fl.exclude do |f|
# 		`git ls-files #{f}`.empty?
# 	end
# end
#
#
#  task abc: :html
# task html: source_files.ext(".html")
#
# rule ".html" => ".md" do |t|
# 	sh "pandoc -o #{t.name} #{t.source}"
# end
#
# rule ".html" => ".markdown" do |t|
# 	sh "pandoc -o #{t.name} #{t.source}"
# end



desc 'Price Comparisons from spreadsheet(2)'
task(:pcp)           { ruby 'database/spreadsheet/report.rb' }

desc 'Build tables from Manufactures/Vendor'
task(:s1)                     { ruby 'adv/adv_base.rb' }

desc 'Find products'
task(:s2)                     { ruby 'adv/adv_search.rb' }
task(:s3)                     { ruby 'adv/adv_product.rb' }


desc 'Install Gems'
task(:install) do
	exec("cd #{Dir.getwd} && bundle clean && bundle update && bundle install")
end

# Rake.application.options.trace = true


