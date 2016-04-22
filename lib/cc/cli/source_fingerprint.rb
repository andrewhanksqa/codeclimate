require "digest/md5"

module CC
  module CLI
    class SourceFingerprint
      def initialize(output)
        @output = output
      end

      def compute
        md5 = Digest::MD5.new
        md5 << key
        md5.hexdigest
      end

      def key
        key = "#{path}|#{check_name}"
        key << "|#{source.gsub(/\s+/, "")}" if source
        key
      end

      private

      attr_reader :output

      def check_name
        output["check_name"]
      end

      def path
        output.fetch("location", {}).fetch("path", "")
      end

      def source
        @source ||= begin
          if line_range
            contents = extract_source

            contents unless contents.blank?
          end
        end
      end

      def line_range
        @line_range ||= begin
          lines = output.fetch("location", {})["lines"]

          if lines
            (lines["begin"]..lines["end"])
          end
        end
      end

      def extract_source
        contents = ""

        File.open(path) do |file|
          file.each_line.with_index do |line, line_number|
            if line_range.include?(line_number + 1)
              contents << line
            end
          end
        end

        contents
      end
    end
  end
end
