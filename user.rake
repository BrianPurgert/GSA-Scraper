desc "Tasks to run from a single computer"

task default: %w[gsa_search]

task :gsa_mft do
	ruby "gsa_advantage_single.rb"
end

task :gsa_search do
	ruby "gsa_advantage_single.rb"
end