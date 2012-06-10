require "rubygems"
require "net/http"
require "net/https"
require "uri"
require "xml-motor"

module Rss
  module WWW

    def self.rss_channel(rssurl)
      xml = http_requester rssurl
      XMLMotor.get_node_from_content xml, 'rss.channel'
    end

    def self.http_requester(httpurl)
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
        return ''
      end
      return '' if response.code.match(/^4/) || response.code.match(/^5/)
      return response.body if response['location'].nil?
      http_requester response['location']
    end
  end
end
