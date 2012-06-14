require 'spec_helper.rb'

describe Rss::Motor do
  before(:all) {
    @response = {
        :title       => 'item2',
        :link        => 'some url_link',
        :description => 'Lorem ipsum dolor sit amet.',
        :author      => 'Doctor Who'
      }
    @url = "http://example.com"
  }

  describe "rss_items" do
    before(:all) do
      Rss::WWW.stubs(:rss_channel).returns([""]) 
      Rss::Proc.stubs(:rss_hashr).returns(@response)       
    end

    it "should return Array of Hashes" do
      data = Rss::Motor.rss_items(@url)
      data.should eq(@response)
    end  
  end

  describe "rss_grep" do

    before(:each) do
      @resp = @response.merge({:title => 'item1'})
      Rss::Motor.stubs(:rss_items).returns([@resp])
    end
      
    it "should return Array of Hashes with the keys are filters" do
      data = Rss::Motor.rss_grep(@url, ['item1', 'item2'])
      data.should eq([{:item1 => [@resp]}, {:item2 => []}])
      data.size.should eq(2)
    end

    it "should return response equal rss_items if filters is empty" do 
      data = Rss::Motor.rss_grep(@url, [])
      data1 = Rss::Motor.rss_items(@url)
      data.should eq(data1)
    end
  end

  describe "rss_grep_link" do
    before(:each) do
      Rss::Motor.stubs(:rss_items).returns([@response])
    end
      
    it "should return Array of Hashes with the keys are filters" do
      data = Rss::Motor.rss_grep_link(@url, ['item1', 'item2'])
      data.should eq([{:item1 => []}, {:item2 => [@response]}])
      data.size.should eq(2)
    end
    
    it "should return response equal rss_items if filters is empty" do 
      data = Rss::Motor.rss_grep_link(@url, [])
      data1 = Rss::Motor.rss_items(@url)
      data.should eq(data1)
    end
  end
  
  describe "item_filter" do
    it "should return true if filter value founded" do
      res = Rss::Motor.item_filter({"title" => "some value"}, "value")
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