require "digest/md5"

module CC
  module Analyzer
    class SourceFingerprint
      def initialize(output)
        @output = output
      end

      def compute
        md5 = Digest::MD5.new
        md5 << path
        md5 << check_name
        md5 << source.gsub(/\s+/, "") if source
        md5.hexdigest
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
        File.open(path) do |file|
          file.each_line.with_object("").with_index do |(line, memo), number|
            memo << line if line_range.include?(number + 1)
          end
        end
      end
    end
  end
end
