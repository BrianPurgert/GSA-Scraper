@queue                    = {}
@queue[:category]         = Queue.new
@queue[:contractors]      = Queue.new
@queue[:manufactures]     = Queue.new
threads     = []

require_relative 'gsa_advantage'
include ADV

import_thread


def queue_base_urls
  letters = ("A".."Z").to_a << '0'
  Thread.new do
    letters.each do |letter|
      ADV::Lists.each do |list|
        ADV::Categories.each do |category|
          add_url"https://www.gsaadvantage.gov/advantage/s/#{list}q=1:4#{category}*&listFor=#{letter}"
        end
      end
    end
  end
end

# Thread for adding URL's to queue
threads << queue_base_urls


# Threads to start Crawler Agents
AGENT_COUNT.times do
  sleep 0.1
  threads << Thread.new do
    initialize_agent
  end
end


# Thread to stop crawler if no url's are queued
threads << crawler_status_thread

# Threads for getting a list of all sub categories
DB[:categories].delete
threads << Thread.new do
ADV::Categories.each do |category|
    html = send_agent("https://www.gsaadvantage.gov/advantage/department/main.do?cat=#{category}")
    doc = Nokogiri::HTML(html)
    department = page_name(doc)
    doc.css("*[href*='search.do'][href*='1:4'][href*='ADV.']").each do |sub_category_link|
      sub_category_name = sub_category_link.text.strip
      href = clean_href(sub_category_link['href'])
      sub_category = href.split('1:4').last
      @queue[:category] << [department, sub_category_name, sub_category]
              ADV::Lists.each do |list|
                add_url"https://www.gsaadvantage.gov/advantage/s/#{list}q=1:4#{sub_category}&listFor=All"
              end
    end
  end
end


# Agent Threads
150.times do
  threads << Thread.new do
    until @url_queue.empty?
      url = take_url
      html = send_agent(url)
      parse_list(html)
    end
  end
end

# close crawler
threads.each { |thr| thr.join }

# Ready a search list for the Product Search Step
puts 'Ready to crawl search pages'

# DB[:items].order(:id).distinct(:id)
























