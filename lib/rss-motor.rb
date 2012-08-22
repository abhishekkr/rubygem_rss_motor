# rss-motor : the motor to speed up your rss interactions

rss_motor_libs = File.join(File.dirname(File.expand_path __FILE__), 'rss-motor', '*.rb')
Dir.glob(rss_motor_libs).each do |lib|
    require lib
end


module Rss
  module Motor

    def self.rss_items(rss_url, more_nodes=[], more_node_keys={})
      rss_data = Rss::WWW.rss_channel rss_url
      return [{}] if rss_data.empty?

      xml_splitd = XMLMotor.splitter rss_data.join
      xml_tags = XMLMotor.indexify xml_splitd
      rss_items = XMLMotor.xmldata xml_splitd, xml_tags, 'item'
      rss_hash = Rss::Proc.rss_hashr rss_items, more_nodes, more_node_keys
    end

    #Returned Array of Hashes, where the keys are given *filters*
    #
    #Example
    #  Rss::Motor.rss_grep 'http://example.com', ['item1', 'item2', 'item3']
    #  [
    #     {'item1' => [{'title' => '....'}, {'title' => '....'}, ...]},
    #     {'item2' => [{'title' => '....'}, {'title' => '....'}, ...]},
    #     {'item3' => [{'title' => '....'}, {'title' => '....'}, ...]}
    #  ]
    #
    def self.rss_grep(rss_urls, filters)
      rss_items = filters.flatten.map{|k| {k => []} }
      [rss_urls].flatten.each do |rss_url|
        rss = rss_items rss_url
        rss.each do |item|
          [filters].flatten.each do |filter|
            rss_items.detect{|a| a.key?(filter)}[filter].push(item) if item_filter(item, filter)
          end
        end
      end
      rss_items
    end

    def self.rss_grep_link(rss_urls, filters)
      rss_items = filters.flatten.map{|k| {k => []} }
      [rss_urls].flatten.each do |rss_url|
        rss = rss_items rss_url
        rss.each do |item|
          link_body = Rss::WWW.http_requester item['link']
          [filters].flatten.each do |filter|
            rss_items.detect{|a| a.key?(filter)}[filter].push(item) if
              item_filter(item, filter) or
              link_body.match(/#{filter}/)
          end
        end
      end
      rss_items
    end


    def self.item_filter(item, filter)
      return false if item.empty? || filter.nil? || filter.strip.empty?
      return !item.values.select{|v| v.match(/#{filter}/i)}.empty?
    end
  end
end

###USAGE EXAMPLES
#puts Rss::Motor.rss_items 'http://news.ycombinator.com/rss'
#puts "*"*100, "#{Rss::Motor.rss_grep 'http://news.ycombinator.com/rss', ['ruby', 'android']}"
#puts "*"*100, "#{Rss::Motor.rss_grep_link 'http://news.ycombinator.com/rss', ['ruby', 'android']}"
#puts Rss::Motor.rss_items 'http://news.ycombinator.com/rss', ['comments']
#puts Rss::Motor.rss_items 'http://feeds.feedburner.com/RubyRogues?format=xml', ['comments'], {'media:content' => 'url'}
