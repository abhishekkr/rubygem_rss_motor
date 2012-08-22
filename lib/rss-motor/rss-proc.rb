module Rss
  module Proc

    def self.rss_hashr(items, more_nodes, more_node_keys)
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
        enclosure = XMLMotor.xmlattrib 'url', item_splitd, item_tags, 'enclosure'
        rss_hash[idx] = {
          'title'       => title.join,
          'link'        => link.join,
          'guid'        => guid.join,
          'description' => description.join,
          'date'        => pubDate.join,
          'author'      => author.join,
          'enclosure'   => enclosure.join
        }

        [more_nodes].flatten.each do |node|
          rss_hash[idx][node] = XMLMotor.xmldata(item_splitd, item_tags, node).join
        end

        more_node_keys.each_pair do |node, key|
          rss_hash[idx][node] = XMLMotor.xmlattrib(key, item_splitd, item_tags, node).join
        end
      end
      return rss_hash
    end
  end
end
