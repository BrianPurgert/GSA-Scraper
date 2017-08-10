
require 'yaml'
require 'pp'
require 'colorize'


yaml_files = Dir.glob(File.join(__dir__, './')+"*.yml")

CONFIG = []
yaml_files.each do |yaml_file|
  puts yaml_file.pretty_inspect.colorize(:yellow)
  yaml = YAML::load_file(File.open(yaml_file, 'rb'))
  puts "#{yaml.pretty_inspect}".colorize(:light_blue)
  CONFIG << yaml
end

