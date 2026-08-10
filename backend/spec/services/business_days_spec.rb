require "rails_helper"

RSpec.describe BusinessDays do
  let(:monday) { Date.current.beginning_of_week(:monday) }
  let(:friday) { monday + 4 }
  let(:saturday) { monday + 5 }
  let(:next_monday) { monday + 7 }

  it "does not count weekends when adding a single business day" do
    expect(described_class.add(friday, 1)).to eq(next_monday)
  end

  it "lands on the following Monday when starting on a weekend" do
    expect(described_class.add(saturday, 1)).to eq(next_monday)
  end

  it "treats a full business week as 5 added days, spanning 7 calendar days" do
    expect(described_class.add(monday, 5)).to eq(next_monday)
  end

  it "calculates 15 business days as exactly 3 calendar weeks" do
    expect(described_class.add(monday, 15)).to eq(monday + 21)
  end
end
