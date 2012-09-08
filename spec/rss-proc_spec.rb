require 'spec_helper.rb'

describe Rss::Proc do
  it "should returned Hash" do
    data = "<item><title>FooBar</title></item>"
    response = Rss::Proc.rss_hashr(data)
    response.should eq([{"title" => "FooBar",  "link"=>"", "guid"=>"", "description"=>"", "date"=>"", "author"=>"", "enclosure"=>""}])
  end

  it "should returned Hash with required Node Value" do
    data          = '<item><title>FooBar</title><uuid>007</uuid></item>'
    required_node = 'uuid'
    response = Rss::Proc.rss_hashr(data, required_node)
    response.should eq([{'title' => 'FooBar',  'link'=>'', 'guid'=>'', 'description'=>'', 'date'=>'', 'author'=>'', 'enclosure'=>'', 'uuid'=>'007'}])
  end

  it "should returned Hash with required Node Value's Attribute, 2nd arg as nil" do
    data        = '<item><title>FooBar</title><uu id="007"/></item>'
    node_attrib = {'uu' => 'id'}
    response    = Rss::Proc.rss_hashr(data, nil, node_attrib)
    response.should eq([{'title' => 'FooBar',  'link'=>'', 'guid'=>'', 'description'=>'', 'date'=>'', 'author'=>'', 'enclosure'=>'', 'uu:id'=>'007'}])
  end

  it "should returned Hash with required Node Value's Attribute, 2nd arg empty" do
    data        = '<item><title>FooBar</title><uu id="007"/></item>'
    node_attrib = {'uu' => 'id'}
    response    = Rss::Proc.rss_hashr(data, [], node_attrib)
    response.should eq([{'title' => 'FooBar',  'link'=>'', 'guid'=>'', 'description'=>'', 'date'=>'', 'author'=>'', 'enclosure'=>'', 'uu:id'=>'007'}])
  end

  it "should returned Hash with 3rd Argument (node-attrib) as non-hash" do
    data        = '<item><title>FooBar</title><uu id="007"/></item>'
    node_attrib = nil
    response    = Rss::Proc.rss_hashr(data, [], node_attrib)
    response.should eq([{'title' => 'FooBar',  'link'=>'', 'guid'=>'', 'description'=>'', 'date'=>'', 'author'=>'', 'enclosure'=>''}])
  end
end
