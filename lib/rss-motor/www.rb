require "rubygems"
require "net/http"
require "net/https"
require "uri"
require "xml-motor"

module Rss
  module WWW

    def self.rss_items(rssurl)
      rss_data = http_requester rssurl, "rss.channel.item"
      Rss::Proc.rss_hashr rss_data
    end

    def self.http_requester(httpurl, node)
      begin
        uri = URI.parse(httpurl)
        http = Net::HTTP.new(uri.host, uri.port)
        if httpurl.match(/^https:\/\//)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
      rescue
        response = nil
      end
      XMLMotor.get_node_from_content response.body, node
    end
  end
end
