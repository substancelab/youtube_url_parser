# frozen_string_literal: true

require "youtube_url_parser"
require "spec_helper"
describe YoutubeUrlParser do
  describe "#parse_as_url" do
    it "returns nil if no string" do
      expect(subject.parse_as_url([])).to eq(nil)
    end

    it "return nil when string empty" do
      expect(subject.parse_as_url("")).to eq(nil)
    end

    it "return nil when not url" do
      expect(subject.parse_as_url("Some weird string")).to eq(nil)
    end

    it "returns nil if no query and not share link" do
      expect(subject.parse_as_url("https://www.youtube.com/watch")).to eq(nil)
    end

    it "returns nil when share link host is wrong" do
      expect(subject.parse_as_url("https://youtubeisdead/9SOa5zLrDDU")).to eq(nil)
    end

    it "returns nil when protocol is missing and no query" do
      expect(subject.parse_as_url("youtu.be/9SOa5zLrDDU")).to eq(nil)
    end

    it "returns nil when embed link has wrong path, missing the 'embed' part" do
      embed_link = '<iframe width="560" height="315" src="https://www.youtube.com/9SOa5zLrDDU" frameborder="0" allowfullscreen></iframe>'
      expect(subject.parse_as_url(embed_link)).to eq(nil)
    end

    context "valid input" do
      it "returns input when link" do
        expect(
          subject.parse_as_url(
            "https://www.youtube.com/watch?v=CxMLsGrAP4A&feature=youtu.be"
          )
        ).to eq("https://www.youtube.com/watch?v=CxMLsGrAP4A")
      end

      it "returns input when link" do
        expect(subject.parse_as_url("https://www.youtube.com/watch?v=Y8QRPjxL87Q")).to eq("https://www.youtube.com/watch?v=Y8QRPjxL87Q")
      end

      it "returns input when link and no protocol" do
        expect(subject.parse_as_url("www.youtube.com/watch?v=Y8QRPjxL87Q")).to eq("https://www.youtube.com/watch?v=Y8QRPjxL87Q")
      end

      it "returns input when share link" do
        expect(subject.parse_as_url("https://youtu.be/9SOa5zLrDDU")).to eq("https://www.youtube.com/watch?v=9SOa5zLrDDU")
      end

      it "returns input when embed link" do
        embed_link = '<iframe width="560" height="315" src="https://www.youtube.com/embed/9SOa5zLrDDU" frameborder="0" allowfullscreen></iframe>'
        expect(subject.parse_as_url(embed_link)).to eq("https://www.youtube.com/watch?v=9SOa5zLrDDU")
      end

      it "returns viewable url when short url" do
        short_url = "https://youtube.com/shorts/pMcXj_PBy94"
        expect(subject.parse_as_url(short_url)).to eq("https://www.youtube.com/watch?v=pMcXj_PBy94")
      end

      it "returns viewable url when short url with share feature param" do
        short_url = "https://youtube.com/shorts/pMcXj_PBy94?feature=share"
        expect(subject.parse_as_url(short_url)).to eq("https://www.youtube.com/watch?v=pMcXj_PBy94")
      end

      it "returns input when embed link is missing the iframe tags and options" do
        embed_link = 'src="https://www.youtube.com/embed/9SOa5zLrDDU"'
        expect(subject.parse_as_url(embed_link)).to eq("https://www.youtube.com/watch?v=9SOa5zLrDDU")
      end

      it "returns input when embed link includes a div for some reason" do
        embed_link = "<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/LKIrFbr1-DM?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>"
        expect(subject.parse_as_url(embed_link)).to eq("https://www.youtube.com/watch?v=LKIrFbr1-DM")
      end
    end
  end

  describe "#parse" do
    context "invalid input" do
      it "returns nil if no string" do
        expect(subject.parse([])).to eq(nil)
      end

      it "return nil when string empty" do
        expect(subject.parse("")).to eq(nil)
      end

      it "return nil when not url" do
        expect(subject.parse("Some weird string")).to eq(nil)
      end

      it "returns nil if no query and not share link" do
        expect(subject.parse("https://www.youtube.com/watch")).to eq(nil)
      end

      it "returns nil when share link host is wrong" do
        expect(subject.parse("https://youtubeisdead/9SOa5zLrDDU")).to eq(nil)
      end

      it "returns nil when protocol is missing and no query" do
        expect(subject.parse("youtu.be/9SOa5zLrDDU")).to eq(nil)
      end

      it "returns nil when embed link has wrong path, missing the 'embed' part" do
        embed_link = '<iframe width="560" height="315" src="https://www.youtube.com/9SOa5zLrDDU" frameborder="0" allowfullscreen></iframe>'
        expect(subject.parse(embed_link)).to eq(nil)
      end
    end

    context "valid input" do
      it "returns query id when link" do
        expect(
          subject.parse(
            "https://www.youtube.com/watch?v=CxMLsGrAP4A&feature=youtu.be"
          )
        ).to eq("CxMLsGrAP4A")
      end

      it "returns query id when link" do
        expect(subject.parse("https://www.youtube.com/watch?v=Y8QRPjxL87Q")).to eq("Y8QRPjxL87Q")
      end

      it "returns query id when link and no protocol" do
        expect(subject.parse("www.youtube.com/watch?v=Y8QRPjxL87Q")).to eq("Y8QRPjxL87Q")
      end

      it "returns query id when share link" do
        expect(subject.parse("https://youtu.be/9SOa5zLrDDU")).to eq("9SOa5zLrDDU")
      end

      it "returns query id when embed link" do
        embed_link = '<iframe width="560" height="315" src="https://www.youtube.com/embed/9SOa5zLrDDU" frameborder="0" allowfullscreen></iframe>'
        expect(subject.parse(embed_link)).to eq("9SOa5zLrDDU")
      end

      it "returns query id when short url" do
        short_url = "https://youtube.com/shorts/pMcXj_PBy94"
        expect(subject.parse(short_url)).to eq("pMcXj_PBy94")
      end

      it "returns query id when short includes share feature param" do
        short_url = "https://youtube.com/shorts/pMcXj_PBy94?feature=share"
        expect(subject.parse(short_url)).to eq("pMcXj_PBy94")
      end

      it "returns query id when embed link is missing the iframe tags and options" do
        embed_link = 'src="https://www.youtube.com/embed/9SOa5zLrDDU"'
        expect(subject.parse(embed_link)).to eq("9SOa5zLrDDU")
      end

      it "returns query id when embed link includes a div for some reason" do
        embed_link = "<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"https://www.youtube.com/embed/LKIrFbr1-DM?ecver=2\" width=\"640\" height=\"360\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>"
        expect(subject.parse(embed_link)).to eq("LKIrFbr1-DM")
      end
    end
  end
end
