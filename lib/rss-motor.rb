# rss-motor : the motor to speed up your rss interactions

rss_motor_libs = File.join(File.dirname(File.expand_path __FILE__), 'rss-motor', '*.rb')
Dir.glob(rss_motor_libs).each do |lib|
    require lib
end


module Rss
  module Motor

    def self.rss_items(rss_url)
      rss_data = Rss::WWW.rss_channel rss_url
      return [{}] if rss_data.empty?
      Rss::Proc.rss_hashr rss_data.join
    end

    def self.rss_grep(rss_urls, filters)
      rss_items = []
      [rss_urls].flatten.each do |rss_url|
        rss = rss_items rss_url
        rss.each do |item|
          [filters].flatten.each do |filter|
            rss_items.push item if item_filter(item, filter)
          end
        end
      end
      rss_items
    end

    def self.rss_grep_link(rss_urls, filters)
      rss_items = []
      [rss_urls].flatten.each do |rss_url|
        rss = rss_items rss_url
        rss.each do |item|
          link_body = Rss::WWW.http_requester item['link']
          [filters].flatten.each do |filter|
            rss_items.push item if
              item_filter(item, filter) or
              link_body.match(/#{filter}/)
          end
        end
      end
      rss_items
    end

    def self.item_filter(item, filter)
      return false if item.empty? || filter.nil?
      return true if
        item['title'].match(/#{filter}/) or
        item['link'].match(/#{filter}/) or
        item['guid'].match(/#{filter}/) or
        item['description'].match(/#{filter}/) or
        item['date'].match(/#{filter}/) or
        item['author'].match(/#{filter}/) or
        item['enclosure'].match(/#{filter}/)
      return false
    end
  end
end

#puts Rss::Motor.rss_items 'http://news.ycombinator.com/rss'
#puts "*"*100, "#{Rss::Motor.rss_grep 'http://news.ycombinator.com/rss', ['ruby', 'android']}"
#puts "*"*100, "#{Rss::Motor.rss_grep_link 'http://news.ycombinator.com/rss', ['ruby', 'android']}"
