require 'hql/query'

describe HQL::Query do

  describe "#valid?" do
    context "with single condition" do
      context "in single quotes" do
        subject { HQL::Query.new("host = 's1.example.org'").valid? }
        it do
          expect(subject).to eq true
        end
      end
      context "in double quotes" do
        subject { HQL::Query.new("host = \"s1.example.org\"").valid? }
        it do
          expect(subject).to eq true
        end
      end
      context "that is invalid" do
        subject { HQL::Query.new("host = 's1.example.org").valid? }
        it do
          expect(subject).to eq false
        end
      end
    end
  end

  describe "#to_sql" do
    context "with single condition" do
      context "in single quotes" do
        subject { HQL::Query.new("host = 's1.example.org'").to_sql }
        it do
          expect(subject).to eq "data->>'host' = 's1.example.org'"
        end
      end
      context "in double quotes" do
        subject { HQL::Query.new("host = \"s1.example.org\"").to_sql }
        it do
          expect(subject).to eq "data->>'host' = 's1.example.org'"
        end
      end
      context "that is invalid" do
        subject { HQL::Query.new("host = 's1.example.org").to_sql }
        it do
          expect(subject).to eq nil
        end
      end
    end
    context "with multiple conditions" do
      context "in single quotes" do
        subject { HQL::Query.new("host = 's1.example.org' path = '/test'").to_sql }
        it do
          expect(subject).to eq "data->>'host' = 's1.example.org' AND data->>'path' = '/test'"
        end
      end
      context "in double quotes" do
        subject { HQL::Query.new("host = \"s1.example.org\" path = \"/test\"").to_sql }
        it do
          expect(subject).to eq "data->>'host' = 's1.example.org' AND data->>'path' = '/test'"
        end
      end
      context "where one is invalid" do
        subject { HQL::Query.new("host = 's1.example.org' AND path = /test'").to_sql }
        it do
          expect(subject).to eq "data->>'host' = 's1.example.org'"
        end
      end
    end
  end

end
