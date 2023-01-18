# frozen_string_literal: true

require "activemodel-youtube_url_parser"
require "spec_helper"

describe ActivemodelYoutubeUrlParser do
  describe "#parse_as_url" do
    it "returns nil if no string" do
      expect(subject.parse_as_url([])).to be_nil
    end

    it "return nil when string empty" do
      expect(subject.parse_as_url("")).to be_nil
    end

    it "return nil when not url" do
      expect(subject.parse_as_url("Jens hansen præsenterer")).to be_nil
    end

    it "returns nil if no query and not share link" do
      expect(subject.parse_as_url("https://www.youtube.com/watch")).to be_nil
    end

    it "returns nil when share link host is wrong" do
      expect(subject.parse_as_url("https://youtubeisdead/9SOa5zLrDDU")).to be_nil
    end

    it "returns nil when protocol is missing and no query" do
      expect(subject.parse_as_url("youtu.be/9SOa5zLrDDU")).to be_nil
    end

    it "returns nil when embed link has wrong path, missing the 'embed' part" do
      embed_link = \
        '<iframe width="560" height="315" src="https://www.youtube.com/9SOa5zLrDDU" frameborder="0" ' \
        "allowfullscreen></iframe>"
      expect(subject.parse_as_url(embed_link)).to be_nil
    end

    context "with valid input" do
      it "returns input when link includes feature param" do
        expect(
          subject.parse_as_url(
            "https://www.youtube.com/watch?v=CxMLsGrAP4A&feature=youtu.be"
          )
        ).to eq("https://www.youtube.com/watch?v=CxMLsGrAP4A")
      end

      it "returns input when link" do
        expect(
          subject.parse_as_url(
            "https://www.youtube.com/watch?v=Y8QRPjxL87Q"
          )
        ).to eq("https://www.youtube.com/watch?v=Y8QRPjxL87Q")
      end

      it "returns input when link and no protocol" do
        expect(
          subject.parse_as_url(
            "www.youtube.com/watch?v=Y8QRPjxL87Q"
          )
        ).to eq("https://www.youtube.com/watch?v=Y8QRPjxL87Q")
      end

      it "returns input when share link" do
        expect(
          subject.parse_as_url(
            "https://youtu.be/9SOa5zLrDDU"
          )
        ).to eq("https://www.youtube.com/watch?v=9SOa5zLrDDU")
      end

      it "returns input when embed link" do
        embed_link = \
          '<iframe width="560" height="315" src="https://www.youtube.com/embed/9SOa5zLrDDU" frameborder="0" ' \
          "allowfullscreen></iframe>"
        expect(subject.parse_as_url(embed_link)).to eq("https://www.youtube.com/watch?v=9SOa5zLrDDU")
      end

      it "returns input when embed link is missing the iframe tags and options" do
        embed_link = 'src="https://www.youtube.com/embed/9SOa5zLrDDU"'
        expect(subject.parse_as_url(embed_link)).to eq("https://www.youtube.com/watch?v=9SOa5zLrDDU")
      end

      it "returns input when embed link includes a div for some reason" do
        expect(
          subject.parse_as_url(embed_link_with_div)
        ).to eq("https://www.youtube.com/watch?v=LKIrFbr1-DM")
      end
    end
  end

  describe "#parse" do
    context "with invalid input" do
      it "returns nil if no string" do
        expect(subject.parse([])).to be_nil
      end

      it "return nil when string empty" do
        expect(subject.parse("")).to be_nil
      end

      it "return nil when not url" do
        expect(subject.parse("Jens hansen præsenterer")).to be_nil
      end

      it "returns nil if no query and not share link" do
        expect(subject.parse("https://www.youtube.com/watch")).to be_nil
      end

      it "returns nil when share link host is wrong" do
        expect(subject.parse("https://youtubeisdead/9SOa5zLrDDU")).to be_nil
      end

      it "returns nil when protocol is missing and no query" do
        expect(subject.parse("youtu.be/9SOa5zLrDDU")).to be_nil
      end

      it "returns nil when embed link has wrong path, missing the 'embed' part" do
        embed_link = \
          '<iframe width="560" height="315" src="https://www.youtube.com/9SOa5zLrDDU" ' \
          'frameborder="0" allowfullscreen></iframe>'
        expect(subject.parse(embed_link)).to be_nil
      end
    end

    context "with valid input" do
      it "returns query id when link includes feature param" do
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
        embed_link = \
          '<iframe width="560" height="315" src="https://www.youtube.com/embed/9SOa5zLrDDU" ' \
          'frameborder="0" allowfullscreen></iframe>'
        expect(subject.parse(embed_link)).to eq("9SOa5zLrDDU")
      end

      it "returns query id when embed link is missing the iframe tags and options" do
        embed_link = 'src="https://www.youtube.com/embed/9SOa5zLrDDU"'
        expect(subject.parse(embed_link)).to eq("9SOa5zLrDDU")
      end

      it "returns query id when embed link includes a div for some reason" do
        expect(subject.parse(embed_link_with_div)).to eq("LKIrFbr1-DM")
      end
    end
  end

  private

  def embed_link_with_div
    "<div style=\"position:relative;height:0;padding-bottom:56.25%\">" \
      "<iframe src=\"https://www.youtube.com/embed/LKIrFbr1-DM?ecver=2\" " \
      "width=\"640\" height=\"360\" frameborder=\"0\" " \
      "style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>"
  end
end
