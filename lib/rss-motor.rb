# rss-motor : the motor to speed up your rss interactions

rss_motor_libs = File.join(File.dirname(File.expand_path __FILE__), 'rss-motor', '*.rb')
Dir.glob(rss_motor_libs).each do |lib|
    require lib
end


module Rss
  module Motor

    def self.rss_items(rss_url)
      rss_data = Rss::WWW.http_requester rss_url, 'rss.channel'
      Rss::Proc.rss_hashr rss_data.join
    end

    def self.rss_grep(rss_urls, filters)
      rss_items = []
      [rss_urls].flatten.each do |rss_url|
        rss = rss_items rss_url
        rss.each do |item|
          [filters].flatten.each do |filter|
            rss_items.push item if
              item['title'].match(/#{filter}/) or
              item['link'].match(/#{filter}/) or
              item['guid'].match(/#{filter}/) or
              item['description'].match(/#{filter}/) or
              item['date'].match(/#{filter}/) or
              item['author'].match(/#{filter}/) or
              item['enclosure'].match(/#{filter}/)
          end
        end
      end
      rss_items
    end

  end
end

#p Rss::Motor.rss_items 'http://news.ycombinator.com/rss'
p Rss::Motor.rss_grep 'http://news.ycombinator.com/rss', ['ruby', 'android']
