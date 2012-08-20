module Rss
  module Proc

    def self.rss_hashr(rss_data)
      splitd = XMLMotor.splitter rss_data
      tags = XMLMotor.indexify splitd
      items = XMLMotor.xmldata splitd, tags, 'item'

      rss_hash = []
      items.each_with_index do |item, idx|
        item_splitd = XMLMotor.splitter item
        item_tags = XMLMotor.indexify item_splitd
        title = XMLMotor.xmldata item_splitd, item_tags, 'title'
        link = XMLMotor.xmldata item_splitd, item_tags, 'link'
        guid = XMLMotor.xmldata item_splitd, item_tags, 'guid'
        description = XMLMotor.xmldata item_splitd, item_tags, 'description'
        pubDate = XMLMotor.xmldata item_splitd, item_tags, 'pubDate'
        author = XMLMotor.xmldata item_splitd, item_tags, 'author'
        enclosure = XMLMotor.xmldata item_splitd, item_tags, 'enclosure', nil, true
        rss_hash[idx] = {
          'title'       => title.join,
          'link'        => link.join,
          'guid'        => guid.join,
          'description' => description.join,
          'date'        => pubDate.join,
          'author'      => author.join,
          'enclosure'   => enclosure.join
        }
      end
      return rss_hash
    end
  end
end
