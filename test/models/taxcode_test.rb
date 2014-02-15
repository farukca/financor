require "test_helper"

describe Taxcode do
  before do
    @taxcode = Taxcode.new
  end

  it "must be valid" do
    @taxcode.valid?.must_equal true
  end
end
