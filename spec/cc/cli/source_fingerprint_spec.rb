require "spec_helper"
require "cc/yaml"

module CC::CLI
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

        expect(fingerprint.key).to eq("spec/fixtures/source.rb|Check/Name|defrunp\"Runrunrun!\"end")
        expect(fingerprint.compute).to eq("25949d75bcd87691e1fc5ec0797ec560")
      end

      it "includes partial source for fingerprint key" do
        output["location"]["lines"] = {
          "begin" => 5,
          "end" => 100
        }

        fingerprint = SourceFingerprint.new(output)

        expect(fingerprint.key).to eq("spec/fixtures/source.rb|Check/Name|end")
        expect(fingerprint.compute).to eq("3a291ef72c949c93598ae81ef8a4dc1c")
      end

      it "does not include source in the key if not readable" do
        output["location"]["lines"] = {
          "begin" => 1000,
          "end" => 1000
        }

        fingerprint = SourceFingerprint.new(output)

        expect(fingerprint.key).to eq("spec/fixtures/source.rb|Check/Name")
        expect(fingerprint.compute).to eq("dc2268e4e6b238fde612a9826dcdbbb2")
      end
    end
  end
end
