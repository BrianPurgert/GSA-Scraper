require_relative 'gsa_advantage'
require 'benchmark'


n_url_thr = 100
n_thr = 3
n_total = n_thr*n_url_thr
page_urls = get_mfr_part(n_total)
url_set   = page_urls.each_slice(n_url_thr).to_a

gsa_a = []

url_set.in_threads(n_thr).each_with_index do |urls, i|
	gsa_a[i] = initialize_browser
	urls.each do |url|
		gsa_a[i].browser.goto "#{url}&cview=true"
		gsa_a[i].browser.wait
		title = gsa_a[i].browser.title
		actual_url = gsa_a[i].browser.url
		unless title.include? 'Product Detail'
			raise 'Product Detail not in title'
		end
	
		text = gsa_a[i].main
		html = gsa_a[i].main_element.html
		gsin = save_page(html, gsa_a[i], text)
		color_p "#{i}|#{title} | #{gsin}",i
		end
end


# html.delete! "\n"
# comments = html.split("<!--")
# comments.each { |comment| comment.strip!; color_p comment }
# "hello".start_with?("heaven", "hell")
# "  hello  ".rstrip   #=> "  hello"
# "  hello  ".lstrip   #=> "hello  "



#execute_script(script, *args) ⇒ Object
#alert ⇒ Watir::Alert
#close ⇒ Object (also: #quit)
#after_hooks ⇒ Object rea
