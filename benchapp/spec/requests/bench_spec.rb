require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/bench" do
  before(:each) do
    @response = request("/bench")
  end
end