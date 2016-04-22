require "digest/md5"

module CC
  module Analyzer
    class PathFingerprint
      def initialize(issue)
        @issue = issue
      end

      def compute
        md5 = Digest::MD5.new
        md5 << issue.path
        md5 << "|"
        md5 << issue.check_name.to_s
        md5.hexdigest
      end

      private

      attr_reader :issue
    end
  end
end
