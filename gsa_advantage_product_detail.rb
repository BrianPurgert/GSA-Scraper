require_relative 'gsa_advantage'
require 'benchmark'




get_mfr_part.in_threads.each do |val|
	myb = initialize_browser
	myb.browser.goto "#{val}"
color_p "#{myb.browser.title} | #{myb.browser.url}"
text = myb.main
html = myb.main_element.html
save_page(html, myb, text)
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
