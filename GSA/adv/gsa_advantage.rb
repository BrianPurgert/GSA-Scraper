
AGENT_COUNT = 40

@agents         = []
@free_agents    = Queue.new
@agent_count        = 0

@url_queue      = Queue.new
@empty_count    = 0
@release        = false



module ADV
  require 'yaml'
  require 'pp'
  require 'colorize'
  require 'benchmark'
  require 'colorize'
  require 'colorized_string'
  require 'htmlbeautifier'
  require 'nokogiri'
  require 'open-uri'
  require 'page-object'
  require 'page-object/page_factory'
  require 'rubygems'
  require 'watir'
  require 'mechanize'


  require_relative '../../config/adv_scrape'
  require_relative 'adv_parse'
  require_relative File.dirname(__FILE__) + '/../../database/database'
  require_relative File.dirname(__FILE__) + '/../../pages/gsa_advantage_page'
  # require_relative '../azure/storage_queue'

#-------------------------- Multi Agent --------------------------
  def take_agent
    while @free_agents.empty?
      print 'A'
      sleep 5
    end
    agent_number = @free_agents.pop
    # color_p "Taking Agent: #{agent_number}", 11
    agent_number
  end

  def release_agent(agent_number)
    @free_agents << agent_number
     # color_p "Released Agent: #{agent_number}", 11
  end

  def new_agent
    agent_number = @agent_count
    @agent_count = @agent_count + 1
    # color_p "Starting Agent: #{agent_number}", 11
    agent_number
  end
#-------------------------- URL Queue --------------------------
  def add_url(url)
    # queue_url url
    color_p "Added #{url}", 12
     @url_queue << url
  end

  def take_url
    # url = dequeue_url
    while @url_queue.empty?
      sleep 1
    end
    url = @url_queue.pop
    color_p "Took #{url}", 12
    url
  end

  def crawler_status_thread
    Thread.new do
      color_p "Status Thread Started", 15
      until @release
        sleep 10
        if (@empty_count > 10) && @url_queue.empty? && @queue[:manufactures].empty? && @queue[:contractors].empty?
          puts "All Queues Empty".colorize(:green)
          @release = true
        elsif @url_queue.empty?
           @empty_count = @empty_count + 1
          puts "No URL's in queue for: #{@empty_count}0".colorize(:red)
        else
          @empty_count = 0
        end
      end
    end
  end
# -------------------------------





def color_p(str,i=-1)
	case i
		when -1
			out_color = String.colors.sample
		else
			out_color = String.colors[i]
	end
	  puts "#{str}".colorize(out_color)
end


# GS-27F-035BA
def search_url(url_encoded_name, current_lowest_price, page_number=1,high_low=true)

	url         = "#{GSA_ADVANTAGE}/advantage/s/search.do?"

  url = url + @search_in
	url = url + "#{url_encoded_name}"
	url = url + "&q=14:7#{current_lowest_price}"                # show price lower than current_lowest_price
	url = url + "&c=100"
	url = url + (high_low ? '&s=9' : '&s=6')
	url = url + (IGNORE_CAT ? '' : "&q=1:4#{category}*")
	# url = url + "searchType=#{search_type}"
	url = url + "&p=#{page_number}"
	# puts url
	# todo save to db
	return url
end




def initialize_agent
  agent_number = new_agent

	proxy      = PROXY_LIST.sample.partition(":")
	user_agent = Mechanize::AGENT_ALIASES.keys.sample
	url        = "https://www.gsaadvantage.gov/advantage/search/headerSearch.do"
	@agents[agent_number]      = Mechanize.new
	if DEBUG_AGENTS
		(@agents[agent_number].log = Logger.new ($stdout))
	end
	
	@agents[agent_number].user_agent_alias = user_agent
	@agents[agent_number].set_proxy proxy[0], proxy[2]
	response = @agents[agent_number].get(url)
	color_p "#{response.code} | #{proxy[0]} | #{response.uri}"
  release_agent(agent_number)
  # @agents[agent_number]
end

def restart_browser(gsa_a)
	gsa_a.browser.close
	return initialize_browser
end

def initialize_browser
	begin
		MECHANIZED ? (return initialize_agent) : (return initialize_browser_s)
	rescue Exception => e
		color_p e.message
		MECHANIZED ? (return initialize_agent) : (return initialize_browser_s)
	end
end

def initialize_browser_s
	  r_proxy      = PROXY_LIST.sample

		options = Selenium::WebDriver::Chrome::Options.new(args: ["headless", "disable-gpu","proxy-server=#{r_proxy}"])
		browser = Watir::Browser.start 'https://www.gsaadvantage.gov/advantage/search/headerSearch.do', :chrome, options: options
		gsa_a   = GsaAdvantagePage.new(browser)
		unless gsa_a.title.include? 'Welcome to GSA Advantage!'
			raise 'Welcome to GSA Advantage! not in title'
		end
		puts "#{gsa_a.title} | #{r_proxy} | ".colorize(:blue)
		return gsa_a
end

def send_agent(url)
  agent_number = take_agent
  color_p "#{agent_number} | #{url}"
	if MECHANIZED
    begin
      puts @agents[agent_number].visited?(url)
      page = @agents[agent_number].get url
    rescue
      puts "Agent #{agent_number} dead".colorize(:red)
      sleep 5
      @agents[agent_number] = initialize_browser
			page = @agents[agent_number].get url
    end


			color_p "Agent: #{agent_number} Code: #{page.code}", 7
		html = page.body

	else
    @agents[agent_number].browser.goto url
		html = @agents[agent_number].html
	end
	save_page(html, url) if DOWNLOAD
  release_agent(agent_number)
  html
end



  def save_page(html, url)
     url = clean_href(url)
     url.split('?')
    #   html = HtmlBeautifier.beautify(html)
     #  create_directory(dirname)
    # short_url = 'url'
    # open(ph, 'w') { |f| f.puts html }
  end

  end
