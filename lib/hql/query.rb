module HQL

  class Query

    def initialize(query_string)
      @query_string = query_string
    end

    def to_sql
      match = @query_string.match(/([a-z]+) \= ['"]([^'"]+)['"]/)
      pairs = {}
      if match[1]
        pairs[match[1]] = match[2]
      end
      pairs.map { |field, value| "data->>'#{field}' = '#{value}'" }.join(' AND ')
    end

  end

end
