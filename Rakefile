$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'sockettp'
require 'json'

desc 'Runs the Sockettp server on the default port, serving the dir in the $SOCKETTP_DIR env var'
task :server do
  args = [ENV['SOCKETTP_DIR']]
  args << ENV['SOCKETTP_PORT'] if ENV['SOCKETTP_PORT']

  Sockettp::Server.start(*args)
end

desc 'Runs a REPL that takes every input line and originates a request to a server in the localhost. The input should contain the path to the remote file, without the leading forward slash'
task :client do
  port = ENV['SOCKETTP_PORT'] || ''

  loop do
    print '>> '
    puts Sockettp::Client.request("sockettp://0.0.0.0#{":#{port}" if port}/#{STDIN.gets.chomp}").to_json
  end
end
