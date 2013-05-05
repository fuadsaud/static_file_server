# encoding: UTF-8

require 'erb'

module StaticFileServer
  class Content

    DIR_LISTING_TEMPLATE = File.read(
                             File.join(
                               File.dirname(__FILE__), 'dir_listing.erb'))

    attr_reader :data, :length, :modification_time, :etag

    def initialize(relative_path, modified_since)
      path = File.join(StaticFileServer.dir, relative_path)

      if File.file?(path)
        if modified_since and modified_since > File.mtime(path)
          raise Status[304]
        end

        @data = File.read(path)
        @modification_time = File.mtime(path)
        @etag = Digest::SHA1.hexdigest(@data)
      elsif File.directory?(path)
        @data = ERB.new(DIR_LISTING_TEMPLATE).result(binding)
      else
        raise Status[404]
      end

      @length = @data.bytesize if @data
    end
  end
end
