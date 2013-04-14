module HTTP
  module Server
    class Request

      attr_reader :path, :method, :header, :http_version

      def initialize(raw_request)
        lines = raw_request.lines.to_a

        # Parse first line.
        @method, @path, @http_version = lines.first.split(' ')

        # Parse the rest of lines (key-value structure)
        @header = parse_header(lines[1..-1].join($/))
      end

      private

      def parse_header(raw)
        header = {}
        field = nil

        raw.each_line do |line|
          case line
          when /^([A-Za-z0-9!\#$%&'*+\-.^_`|~]+):\s*(.*?)\s*\z/om
            field, value = $1, $2
            header[field] = value
          when /^\s+(.*?)\s*\z/om
            value = $1
            fail "bad header '#{line}'." unless field

            header[field][-1] << " " << value
          else
            fail "bad header '#{line}'."
          end
        end

        header.each do |key, value|
          value.strip!
          value.gsub!(/\s+/, " ")
        end

        header
      end
    end
  end
end