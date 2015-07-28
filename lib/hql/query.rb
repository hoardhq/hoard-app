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
        matches = @query_string.scan(/([a-z]+) \= ['"]([^'"]+)['"]/)
        matches.each do |match|
          @pairs[match[0]] = match[1]
        end
        true
      end
    end

  end

end
