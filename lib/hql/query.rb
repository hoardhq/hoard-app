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
      @pairs.sort_by { |k, v| k }.map do |field, value|
        operator = "="
        if value[0] == "~"
          operator = "LIKE"
          value[1] = "%#{value[1]}%"
        end
        "data->>'#{field}' #{operator} '#{value[1].gsub("\\", "").gsub("'", "''")}'"
      end.join(' AND ')
    end

    private

    def build
      @build ||= begin
        query_string = @query_string.dup
        matches = query_string.scan(/(?<all>(?<field>[a-z]+)[ ]*(?<operator>(=|~))[ ]*(?<quote>['"])(?<value>.*?)\k<quote>)/)
        matches.each do |match|
          @pairs[match[1]] = [match[2], match[4]] if match[4]
          query_string.gsub! match[0], ''
        end
        matches = query_string.scan(/(?<field>[a-z]+)[ ]*(?<operator>(=|~))[ ]*(?<value>[^\s'"]+)/)
        matches.each do |match|
          @pairs[match[0]] = [match[1], match[2]] if match[2]
        end
        true
      end
    end

  end

end
