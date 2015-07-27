require 'hql/query'

describe HQL::Query do

  describe "#to_sql" do

    context "with single condition" do
      subject { HQL::Query.new("host = 's1.example.org'").to_sql }
      it do
        expect(subject).to eq "data->>'host' = 's1.example.org'"
      end
    end
  end

end
