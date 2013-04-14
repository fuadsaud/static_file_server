module HTTP
  module Server
    class Content

      attr_reader :data, :length

      def initialize(path)
        path = File.join(Server.dir, path)

        if File.file?(path)
          @data = File.read(path)
        elsif File.directory?(path)
          @data = Dir.entries(path).to_s
        end

        @length = @data.bytesize if @data
      end
    end
  end
end