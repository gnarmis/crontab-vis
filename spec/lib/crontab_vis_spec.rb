require 'spec_helper'

describe CrontabVis do

  describe "#initialize" do
    it "has a configurable anchor_time" do
      t1 = Time.now
      cv = CrontabVis.new(anchor_time: t1)
      expect(cv.anchor_time).to eq(t1.beginning_of_month)
    end
  end

  let(:cv) { CrontabVis.new }

  describe "#next_occurrences" do

    context "for '* * * * *'" do
      context "with default limit of 1 week" do
        it "has the right number of occurrences" do
          expect(cv.next_occurrences('* * * * *').count).
            to eq(24*7*60)
        end
      end
    end

    context "for '5 * * * *'" do
      context "with default limit of 1 week" do
        it "has the right number of occurrences" do
          expect(cv.next_occurrences('5 * * * *').count).
            to eq(24*7)
        end
      end
    end

    context "for '* 12 * * Mon' (every min 12th hour of Mon)" do
      context "with default limit of 1 week" do
        it "has the right number of occurrences" do
          expect(cv.next_occurrences('* 12 * * Mon').count).
            to eq(60)
        end
      end

      context "with limit of 1 month" do
        it "has the right number of occurrences" do
          expect(cv.next_occurrences('* 12 * * Mon', limit: 1.month).count).
            to eq(60*4)
        end
      end
    end

    context "for '59 11 * * 1,2,3,4,5' (11:59am Mon through Fri)" do
      context "with default limit of 1 week" do
        it "has the right number of occurrences" do
          expect(cv.next_occurrences('59 11 * * 1,2,3,4,5').count).
            to eq(5)
        end
      end

      context "with limit of 1 month" do
        it "has the right number of occurrences" do
          expect(
            cv.next_occurrences('59 11 * * 1,2,3,4,5', limit: 1.month).count
          ).to eq(5*4)
        end
      end
    end

    context "for '*/15 9-17 * * *' (every 15 minutes between the 9th and 17th hour of the day)" do
      context "with default limit of 1 week" do
        it "has the right number of occurrences" do
          expect(cv.next_occurrences('*/15 9-17 * * *').count).
            to eq(9*4*7)
        end
      end
    end

    context "for '* 12 16 * *' (every min 12th hour of the 16th of month)" do
      context "with time limit of 1 month" do
        it "has the right number of occurrences" do
          expect(
            cv.next_occurrences('* 12 16 * *', limit: 1.month).count
          ).to eq(60)
        end
      end
    end

  end

end
