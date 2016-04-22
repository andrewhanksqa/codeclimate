require "spec_helper"

module CC::Analyzer
  describe SourceFingerprint do
    describe "#compute" do
      let(:output) do
        output = {
          "check_name" => "Check/Name",
          "location" => {
            "path" => "spec/fixtures/source.rb"
          },
        }
      end

      it "computes a fingerprint by path, check_name, and source" do
        output["location"]["lines"] = {
          "begin" => 2,
          "end" => 4
        }

        fingerprint = SourceFingerprint.new(output)

        expect(fingerprint.compute).to eq("30f53a688723a198cd83d3e3377da7d0")
      end

      it "incorporates partially available source in the fingerprint" do
        output["location"]["lines"] = {
          "begin" => 5,
          "end" => 100
        }

        fingerprint = SourceFingerprint.new(output)

        expect(fingerprint.compute).to eq("84fbb18391c45d63ddc6f8d528d18ae6")
      end

      it "only incorporates source if source is available" do
        output["location"]["lines"] = {
          "begin" => 1000,
          "end" => 1000
        }

        fingerprint = SourceFingerprint.new(output)

        expect(fingerprint.compute).to eq("eef541a28f83417a45808139d58b631d")
      end
    end
  end
end
