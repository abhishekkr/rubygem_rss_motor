require 'spec_helper.rb'

describe Rss::Motor do

  before(:all) do
    @rss_item = <<-RSS
        <items><item>
        <title>item2</title>
        <link>some url_link</link>
        <description>Lorem ipsum dolor sit amet.</description>
        <author>Doctor Who</author>
        <comments>no comment</comments>
        <media:content size='8Bit'/>
        </item></items>
      RSS
    @response = [{
        'title'       => 'item2',
        'link'        => 'some url_link',
        'guid'        => '',
        'description' => 'Lorem ipsum dolor sit amet.',
        'date'        => '',
        'author'      => 'Doctor Who',
        'enclosure'   => ''
      }]

    @for_node = 'comments'
    @response_for_node = {'comments' => 'no comment'}
    @for_node_attrib = {'media:content' => 'size'}
    @response_for_node_attrib = {'media:content:size' => '8Bit'}
    @url = "http://example.com"
  end

  describe "rss_items" do
    before(:each) do
      Rss::WWW.stubs(:rss_channel).returns([@rss_item])
    end

    it "should return Array of Hashes for default-nodes" do
      data = Rss::Motor.rss_items(@url)
      data.should eq(@response)
    end

    it "should return Array of Hashes for default-nodes and extra argument node" do
      data = Rss::Motor.rss_items(@url, @for_node)
      new_response = @response[0].merge @response_for_node
      data.should eq([new_response])
    end

    it "should return Array of Hashes for default-nodes and extra argument nodes array" do
      data = Rss::Motor.rss_items(@url, [@for_node])
      new_response = @response[0].merge @response_for_node
      data.should eq([new_response])
    end

    it "should return Array of Hashes for default-nodes and extra argument node's attribute hash" do
      data = Rss::Motor.rss_items(@url, [], @for_node_attrib)
      new_response = @response[0].merge @response_for_node_attrib
      data.should eq([new_response])
    end

    it "should return Array of Hashes for default-nodes and extra argument nodes array" do
      data = Rss::Motor.rss_items(@url, ['comments'], @for_node_attrib)
      new_response = @response[0].merge(@response_for_node).merge @response_for_node_attrib
      data.should eq([new_response])
    end
  end

  describe "rss_grep" do

    before(:each) do
      @response = {
        'title'       => 'item2',
        'link'        => 'some url_link',
        'description' => 'Lorem ipsum dolor sit amet.',
        'author'      => 'Doctor Who'
      }
      Rss::Motor.stubs(:rss_items).returns([@response])
    end

    it "should return Array of Hashes with the keys are filters" do
      data = Rss::Motor.rss_grep(@url, ['itme1', 'item2'])
      data.size.should eq(2)
    end
  end

  describe "rss_grep_link" do
    before(:each) do
      @response = {
        'title'       => 'item2',
        'link'        => 'some url_link',
        'description' => 'Lorem ipsum dolor sit amet.',
        'author'      => 'Doctor Who'
      }
      Rss::Motor.stubs(:rss_items).returns([@response])
    end

    it "should return Array of Hashes with the keys are filters" do
      data = Rss::Motor.rss_grep_link(@url, ['itme1', 'item2'])
      data.size.should eq(2)
    end
  end

  describe "item_filter" do
    it "should return true if filter value founded" do
      res = Rss::Motor.item_filter({"title" => "some value"}, "value")
      res.should eq(true)
    end

    it "should return true if filter value founded case-insensitive" do
      res = Rss::Motor.item_filter({"title" => "Some Value"}, "value")
      res.should eq(true)
    end

    it "should return false if filter value not founded" do
      res = Rss::Motor.item_filter({"title" => "some value"}, "lorem")
      res.should eq(false)
    end

    it "should return true if item is empty" do
      res = Rss::Motor.item_filter({}, "value")
      res.should eq(false)
    end

    it "should return false if filter is nil" do
      res = Rss::Motor.item_filter({"title" => "some value"}, nil)
      res.should eq(false)
    end

    it "should return false if filter is empty" do
      res = Rss::Motor.item_filter({"title" => "some value"}, "  ")
      res.should eq(false)
    end
  end
end
