require "digest/md5"

module CC
  module Analyzer
    class SourceFingerprint
      def initialize(issue)
        @issue = issue
      end

      def compute
        md5 = Digest::MD5.new
        md5 << issue.path
        md5 << issue.check_name.to_s
        md5 << source.gsub(/\s+/, "") if source
        md5.hexdigest
      end

      private

      attr_reader :issue

      def source
        @source ||= begin
          if (lines = issue.lines)
            contents = extract_source((lines["begin"]..lines["end"]))

            contents unless contents.blank?
          end
        end
      end

      def extract_source(range)
        File.open(issue.path) do |file|
          file.each_line.with_object("").with_index do |(line, memo), number|
            memo << line if range.include?(number + 1)
          end
        end
      end
    end
  end
end
