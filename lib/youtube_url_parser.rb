# frozen_string_literal: true

require "uri"
require "active_model"
require "rack/utils"

class YoutubeUrlParser
  class YoutubeShareUrl
    include ActiveModel::Model
    attr_accessor :link, :uri

    def self.share_link?(link)
      link.include?("/youtu.be")
    end

    def youtube_id
      parse_link
      return nil unless valid_host?

      uri.path.delete("/")
    end

    def parse_link
      self.uri = URI.parse(link)
    end

    private

    def valid_host?
      uri.host == "youtu.be"
    end
  end

  class YoutubeEmbedUrl < YoutubeShareUrl
    def self.embed_link?(link)
      link.include?("embed")
    end

    def youtube_id
      self.link = url_from_embed_link
      parse_link
      link_path = uri.path
      youtube_id = link_path.gsub("/embed/", "")
    end

    private

    def url_from_embed_link
      urls = URI.extract(link)
      urls.find { |url| self.class.embed_link?(url) }
    end
  end

  class YoutubeDirectUrl < YoutubeShareUrl
    def youtube_id
      parse_link
      query = uri.query
      youtube_id = ::Rack::Utils.parse_nested_query(query)
      youtube_id = youtube_id.fetch("v", nil)
    end
  end

  class YoutubeShortUrl < YoutubeShareUrl
    def self.short_link?(link)
      link.include?("short")
    end

    def youtube_id
      self.link = url_from_short_link(link)
      parse_link
      link_path = uri.path
      youtube_id = link_path.gsub("/shorts/", "")
    end

    private

    def url_from_short_link(link)
      urls = URI.extract(link)
      urls.find { |url| self.class.short_link?(url) }
    end
  end

  def parse(link)
    return nil unless link

    youtube_link = define_link(link).new(:link => link)
    youtube_link.youtube_id
  rescue URI::InvalidURIError => error
    nil
  end

  def parse_as_url(link)
    return nil unless link

    youtube_link = define_link(link).new(:link => link)

    if youtube_link.youtube_id.present?
      return "https://www.youtube.com/watch?v=#{youtube_link.youtube_id}"
    end

    nil
  rescue URI::InvalidURIError => error
    nil
  end

  private

  def define_link(link)
    if YoutubeShareUrl.share_link?(link)
      YoutubeShareUrl
    elsif YoutubeEmbedUrl.embed_link?(link)
      YoutubeEmbedUrl
    elsif YoutubeShortUrl.short_link?(link)
      YoutubeShortUrl
    else
      YoutubeDirectUrl
    end
  end
end
