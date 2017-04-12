require 'thread'
require 'watir'

def test_google
		3.times do

				start_time = Time.now

				
				end_time = Time.now
				puts end_time - start_time
		end
end

threads = []
num_threads = 4
num_threads.times do
		threads << Thread.new do
				test_google
		end
end
threads.each do |x|
		x.join
end