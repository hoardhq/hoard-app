require 'hql/query'

describe HQL::Query do

  queries = [
    {
      query: "host = 's1.example.org'",
      sql: "data->>'host' = 's1.example.org'",
      valid: true,
    },
    {
      query: "host = \"s1.example.org\"",
      sql: "data->>'host' = 's1.example.org'",
      valid: true,
    },
    {
      query: "host = \"s1.example.org",
      sql: nil,
      valid: false,
    },
    {
      query: "host = 's1.example.org' path = '/test'",
      sql: "data->>'host' = 's1.example.org' AND data->>'path' = '/test'",
      valid: true,
    }
  ]

  queries.each do |options|

    describe "#valid?" do
      it "#{options[:query]} should be valid" do
        query = HQL::Query.new(options[:query])
        expect(query.valid?).to eq options[:valid]
      end
    end

    describe "#to_sql" do
      it do
        query = HQL::Query.new(options[:query])
        expect(query.to_sql).to eq options[:sql]
      end
    end

  end
end
