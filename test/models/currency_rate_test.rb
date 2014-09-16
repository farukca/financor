require "test_helper"

describe CurrencyRate do
  before do
    @currency_rate = CurrencyRate.new
  end

  it "must be valid" do
    @currency_rate.valid?.must_equal true
  end
end
