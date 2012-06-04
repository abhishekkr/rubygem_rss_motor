module Rss
  module Proc

    def self.rss_hashr(rss_data)
      splitd = XMLMotor.splitter rss_data
      tags = XMLMotor.indexify splitd

      items = XMLMotor.xmldata splitd, tags, 'item'
      titles = XMLMotor.xmldata splitd, tags, 'title'
      links = XMLMotor.xmldata splitd, tags, 'link'
      guids = XMLMotor.xmldata splitd, tags, 'guid'
      descriptions = XMLMotor.xmldata splitd, tags, 'description'
      pubDates = XMLMotor.xmldata splitd, tags, 'pubDate'
      authors = XMLMotor.xmldata splitd, tags, 'author'
      enclosures = XMLMotor.xmldata splitd, tags, 'enclosure'

      rss_hash = []
      for idx in 0..(items.count - 1)
        rss_hash[idx] = {
          'title'       => titles[idx] || '',
          'link'        => links[idx] || '',
          'guid'        => guids[idx] || '',
          'description' => descriptions[idx] || '',
          'date'        => pubDates[idx] || '',
          'author'      => authors[idx] || '',
          'enclosure'   => enclosures[idx] || ''
        }
      end
      return rss_hash
    end
  end
end
