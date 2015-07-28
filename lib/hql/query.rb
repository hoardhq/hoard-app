module HQL

  class Query

    def initialize(query_string)
      @query_string = query_string
      @pairs = {}
    end

    def valid?
      build
      @pairs.length > 0
    end

    def to_sql
      return nil unless valid?
      @pairs.map { |field, value| "data->>'#{field}' = '#{value}'" }.join(' AND ')
    end

    private

    def build
      @build ||= begin
        match = @query_string.match(/([a-z]+) \= ['"]([^'"]+)['"]/)
        if match
          @pairs[match[1]] = match[2]
        end
        true
      end
    end

  end

end
