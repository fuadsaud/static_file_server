# encoding: UTF-8

require 'erb'

module StaticFileServer
  class Content

    DIR_LISTING_TEMPLATE = File.read(
                             File.join(
                               File.dirname(__FILE__), 'dir_listing.erb'))

    attr_reader :data, :length, :modification_time

    def initialize(data, modification_time = Time.now)
      @data = data
      @length = data.bytesize
      @modification_time = modification_time
    end

    def self.from_filesystem(relative_path, modified_since)
      path = File.join(StaticFileServer.dir, relative_path)

      raise Status[404] unless File.exist(path)

      raise Status[304] if modified_since && modified_since <= File.mtime(path)

      data = if File.file?(path)
        File.read(path)
      elsif File.directory?(path)
        ERB.new(DIR_LISTING_TEMPLATE).result(binding)
      end

      new(data, File.mtime(path))
    end
  end
end
