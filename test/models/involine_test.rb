require "test_helper"

describe Involine do
  before do
    @involine = Involine.new
  end

  it "must be valid" do
    @involine.valid?.must_equal true
  end
end
