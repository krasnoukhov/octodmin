require "test_helper"

describe Octodmin::VERSION do
  it "returns current version" do
    Octodmin::VERSION.must_equal "0.1.0"
  end
end
