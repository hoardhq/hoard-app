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
      @pairs.sort_by { |k, v| k }.map { |field, value| "data->>'#{field}' = '#{value.gsub("\\", "").gsub("'", "''")}'" }.join(' AND ')
    end

    private

    def build
      @build ||= begin
        query_string = @query_string.dup
        matches = query_string.scan(/(?<all>(?<field>[a-z]+)[ ]*\=[ ]*(?<quote>['"])(?<value>.*?)\k<quote>)/)
        matches.each do |match|
          @pairs[match[1]] = match[3] if match[3]
          query_string.gsub! match[0], ''
        end
        matches = query_string.scan(/(?<field>[a-z]+)[ ]*\=[ ]*(?<value>[^\s'"]+)/)
        matches.each do |match|
          @pairs[match[0]] = match[1] if match[1]
        end
        true
      end
    end

  end

end
