require 'watir'
require 'page-object/page_factory'
require 'page-object'
require 'spreadsheet'
require_relative 'pages/gsa_advantage_page'
require 'colorize'
require 'colorized_string'
require 'mysql2'
require 'monetize'
require 'yaml'
require 'in_threads'

Bench_time    = [Time.now]
browser       = []
gsa_advantage = []
@search_items = []
@mfr_name     = []
N_threads = 10
N_threads_plus_one = N_threads+1
Proxy_list = YAML::load_file(File.join(__dir__, 'proxy.yml'))


def search_url(mpn, mft)
     return "https://www.gsaadvantage.gov/advantage/s/search.do?q=9,8:0#{mpn}&q=10:2#{mft}&s=0&c=25&searchType=0"
end

def benchmark
     Bench_time << Time.now
     elapsed       = Bench_time[-1] - Bench_time[-2]
     total_elapsed = Bench_time[-1] - Bench_time[0]
     print "\tElapsed: #{total_elapsed}\tSince Last: #{elapsed}\n".colorize(:blue)
end

def initialize_browsers(browser, gsa_advantage)
     Proxy_list.in_threads.each_with_index do |r_proxy,nt|
          browser[nt]       = Watir::Browser.new :chrome, switches: ["proxy-server=#{r_proxy}"]
          gsa_advantage[nt] = GsaAdvantagePage.new(browser[nt])
          # gsa_advantage[nt].browser.goto 'https://ifconfig.co/ip'
          print "\nBrowser #{nt}\t".colorize(:blue)
          print "#{gsa_advantage[nt].browser.text}\t#{r_proxy}"
          # gsa_advantage[nt].browser.driver.manage.window.resize_to(300, 950)
          # gsa_advantage[nt].browser.driver.manage.window.move_to(((nt % 8)*200), 0)
          gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov/'
          gsa_advantage[nt].browser.goto 'https://www.gsaadvantage.gov/advantage/s/search.do?q=9,8:0775&q=10:2BELLEVILLE&s=0&c=25&searchType=0'
          proxy_working = gsa_advantage[nt].first_result_element.exist?
          puts "#{r_proxy} #{proxy_working}"
          # benchmark
     end
end

initialize_browsers(browser, gsa_advantage)