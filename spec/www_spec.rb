require 'spec_helper.rb'

describe Rss::WWW do
  before(:all) {
    @url = 'http://www.example.com'
  }
  describe "http_requester" do
    it "should return nothing if request rescue" do
      stub_request(:any, @url).to_raise(StandardError)
      response = Rss::WWW.http_requester(@url)
      response.should eq("")
    end
    it "should return nothing if response code > 500" do
      stub_request(:any, @url).to_return(:status => [500, "Internal Server Error"])
      response = Rss::WWW.http_requester(@url)
      response.should eq("")
    end
    it "should return nothing if response code > 400" do
      stub_request(:any, @url).to_return(:status => [404, "Not Found"])
      response = Rss::WWW.http_requester(@url)
      response.should eq("")
    end
    it "should return response" do
      stub_request(:any, @url).to_return(:body => "abc")
      response = Rss::WWW.http_requester(@url)
      response.should eq("abc")
    end
  end
end
