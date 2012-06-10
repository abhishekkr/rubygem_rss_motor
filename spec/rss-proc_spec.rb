require 'spec_helper.rb'

describe Rss::Proc do
  it "should returned Hash" do
    data = "<item><title>FooBar</title></item>"
    response = Rss::Proc.rss_hashr(data)
    response.should eq([{"title" => "FooBar",  "link"=>"", "guid"=>"", "description"=>"", "date"=>"", "author"=>"", "enclosure"=>""}])
  end 
end