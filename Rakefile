$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'sockettp'
require 'json'

task :server do
  Sockettp::Server.start(ENV['SOCKETTP_DIR'])
end

task :client do
  loop do
    print '>> '
    puts Sockettp::Client.request("sockettp://0.0.0.0/#{STDIN.gets.chomp}").to_json
  end
end
