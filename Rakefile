task :server do
  require_relative './lib/sockettp'

  Sockettp::Server.new(ENV['SOCKETTP_DIR']).start
end

task :client do
  require_relative './lib/sockettp'

  loop do
    print '>> '
    puts Sockettp::Client.request(STDIN.gets.chomp)
  end
end