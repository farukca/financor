require "test_helper"

describe Invoice do
  before do
    @invoice = Invoice.new
  end

  it "must be valid" do
    @invoice.valid?.must_equal true
  end
end
