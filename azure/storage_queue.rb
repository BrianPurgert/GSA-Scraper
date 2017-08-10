#--------------------------------------------------------------------------


#---------------------------------------------------------------------------

require 'openssl'
require 'azure'
require 'azure/storage'
require File.dirname(__FILE__) + '/./azure_config'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
client = nil

puts 'Starting | Azure Queue Storage'

if AzureConfig::IS_EMULATED
    client = Azure::Storage.client(use_development_storage: true)
  else
    client = Azure::Storage.client(
      storage_account_name: AzureConfig::STORAGE_ACCOUNT_NAME,
      storage_access_key:   AzureConfig::STORAGE_ACCOUNT_KEY
    )
end
QUEUE_SERVICE = Azure::Storage::Queue::QueueService.new(client: client)

puts '---------------------------------------------------------------'
puts 'Connected | Azure Queue Storage'

  queue_suffix = 'horizon'
  QUEUE_NAME = "queue-#{queue_suffix}"
  puts "Creating | queue #{QUEUE_NAME}"
  QUEUE_SERVICE.create_queue(QUEUE_NAME)

  def queue_url(url)
    QUEUE_SERVICE.create_message(QUEUE_NAME, url)
    puts "Queued #{url}"
  end

def dequeue_url
  messages = QUEUE_SERVICE.list_messages(QUEUE_NAME, 60)
  message = messages.first
  QUEUE_SERVICE.delete_message(QUEUE_NAME, message.id, message.pop_receipt)
  puts "Deq: #{message.message_text}"
  message.message_text
end


# Thread.new do
#   while true
#     result = QUEUE_SERVICE.get_queue_metadata(QUEUE_NAME)
#     puts "Approximate length of the Azure queue: #{result[0]}"
#     sleep 15
#   end
# end

queue_url 'www.google.com'
dequeue_url


def peek_urls
  messages = QUEUE_SERVICE.peek_messages(QUEUE_NAME, number_of_messages: 5)
  messages.each { |msg| puts "Up Next: #{msg.message_text}" }
end

def close_queue
  QUEUE_SERVICE.clear_messages(QUEUE_NAME)
  QUEUE_SERVICE.delete_queue(QUEUE_NAME)
end












