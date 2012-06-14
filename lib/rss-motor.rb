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

    #Returned Array of Hashes, where the keys are given *filters*
    # or 
    # Returned Response as rss_items if filters is empty
    #Example
    #  Rss::Motor.rss_grep 'http://example.com', ['item1', 'item2', 'item3']
    #  [
    #     {'item1' => [{'title' => '....'}, {'title' => '....'}, ...]},
    #     {'item2' => [{'title' => '....'}, {'title' => '....'}, ...]},
    #     {'item3' => [{'title' => '....'}, {'title' => '....'}, ...]}
    #  ]
    def self.rss_grep(rss_urls, filters)
      item_create_response(rss_urls, filters, 
             lambda {|item, filter, link_body| (item_filter(item, filter)) })
      
    end

    def self.rss_grep_link(rss_urls, filters)
      item_create_response(rss_urls, filters, 
             lambda {|item, filter, link_body| (item_filter(item, filter) or 
                        link_body.match(/#{filter}/))})
          
    end
    
    def self.item_create_response(rss_urls, filters, exp)
      return rss_items if filters.empty?

      rss_items = filters.flatten.map{|k| {k.to_sym => []} }
      [rss_urls].flatten.each do |rss_url|
        rss = rss_items rss_url
        rss.each do |item|
          link_body = Rss::WWW.http_requester item['link']
          [filters].flatten.each do |filter|
             item_push(rss_items, filter, item) if exp.call(item, filter, link_body)
          end
        end
      end
      rss_items
    
    end

    def self.item_push(collection, filter, item) 
      collection.detect{|a| a.key?(filter.to_sym)}[filter.to_sym].push(item)
    end
    
    def self.item_filter(item, filter)
      return false if item.empty? || filter.nil? || filter.strip.empty?
      return !item.values.select{|v| v.match(/#{filter}/)}.empty?
    end
  end
end

#puts Rss::Motor.rss_items 'http://news.ycombinator.com/rss'
#puts "*"*100, "#{Rss::Motor.rss_grep 'http://news.ycombinator.com/rss', ['ruby', 'android']}"
#puts "*"*100, "#{Rss::Motor.rss_grep_link 'http://news.ycombinator.com/rss', ['ruby', 'android']}"
