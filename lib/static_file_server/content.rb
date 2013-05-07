# encoding: UTF-8

require 'erb'

module StaticFileServer
  class Content

    DIR_LISTING_TEMPLATE = File.read(
                             File.join(
                               File.dirname(__FILE__), 'dir_listing.erb'))

    attr_reader :data, :length, :modification_time, :type

    def initialize(data, modification_time = Time.now, type)
      @data = data
      @length = data.bytesize
      @modification_time = modification_time
      @type = type
    end

    def self.from_filesystem(relative_path, modified_since)
      path = File.join(StaticFileServer.dir, relative_path)

      raise Status[404] unless File.exist?(path)
      raise Status[403] unless File.readable?(path)
      raise Status[304] if modified_since && modified_since <= File.mtime(path)

      data, type = if File.file?(path)
        [File.read(path), `file --mime-type #{path}`.split(' ').last]
      elsif File.directory?(path)
        [ERB.new(DIR_LISTING_TEMPLATE).result(binding), 'text/html']
      end

      new(data, File.mtime(path), type)
    end
  end
end
