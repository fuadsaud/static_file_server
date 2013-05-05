# encoding: UTF-8

module StaticFileServer

  #
  # This module offers some utilities to the server.
  #
  module Utils
    CRLF = "\r\n"

    def self.color_for_status(status)
      case status.code
      when 100...300 then :green
      when 300...400 then :cyan
      when 400...505 then :red
      end
    end
  end
end
