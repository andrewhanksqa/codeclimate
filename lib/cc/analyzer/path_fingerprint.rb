require "digest/md5"

module CC
  module Analyzer
    class PathFingerprint
      def initialize(output)
        @output = output
      end

      def compute
        md5 = Digest::MD5.new
        md5 << key
        md5.hexdigest
      end

      def key
        "#{path}|#{check_name}"
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
