$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'sockettp'
require 'json'

desc 'Runs the Sockettp server on the default port, serving the dir in the $SOCKETTP_DIR env var'
task :server do
  Sockettp::Server.start(ENV['SOCKETTP_DIR'])
end

desc 'Runs a REPL that takes every input line and originates a request to a server in the localhost. The input should contain the path to the remote file, without the leading forward slash'
task :client do
  loop do
    print '>> '
    puts Sockettp::Client.request("sockettp://0.0.0.0/#{STDIN.gets.chomp}").to_json
  end
end
