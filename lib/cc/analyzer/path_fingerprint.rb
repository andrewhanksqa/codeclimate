require "digest/md5"

module CC
  module Analyzer
    class PathFingerprint
      def initialize(output)
        @output = output
      end

      def compute
        md5 = Digest::MD5.new
        md5 << path
        md5 << "|"
        md5 << check_name.to_s
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
    end
  end
end
