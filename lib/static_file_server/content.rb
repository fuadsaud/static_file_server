# encoding: UTF-8

require 'erb'

module StaticFileServer
  class Content

    DIR_LISTING_TEMPLATE = File.read(
                             File.join(
                               File.dirname(__FILE__), 'dir_listing.erb'))

    attr_reader :data, :length

    def initialize(relative_path)
      path = File.join(StaticFileServer.dir, relative_path)

      if File.file?(path)
        @data = File.read(path)
      elsif File.directory?(path)
        @data = ERB.new(DIR_LISTING_TEMPLATE).result(binding)
      end

      @length = @data.bytesize if @data
    end
  end
end
