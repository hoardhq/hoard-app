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
    },
    {
      query: "title = \"Hoard's Page\"",
      sql: "data->>'title' = 'Hoard''s Page'",
      valid: true,
    },
    {
      query: "host = s1.example.org path='/test'",
      sql: "data->>'host' = 's1.example.org' AND data->>'path' = '/test'",
      valid: true,
    },
    {
      query: "path=/ host = s7",
      sql: "data->>'host' = 's7' AND data->>'path' = '/'",
      valid: true,
    },
    {
      query: "path ~ /users/1",
      sql: "data->>'path' LIKE '%/users/1%'",
      valid: true,
    },
    {
      query: "path ~ \"/users/1\" host ~ 's1.'",
      sql: "data->>'host' LIKE '%s1.%' AND data->>'path' LIKE '%/users/1%'",
      valid: true,
    },
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
