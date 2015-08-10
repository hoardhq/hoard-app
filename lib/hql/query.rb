module HQL

  class Query

    def initialize(query_string)
      @query_string = query_string || ""
      @pairs = {}
    end

    def valid?
      build
      @pairs.length > 0
    end

    def uuid
      Digest::SHA1.hexdigest(canonical)[0..15] if canonical
    end

    def to_sql
      return nil unless valid?
      @pairs.sort_by { |k, v| k }.map do |field, options|
        operator = "="
        value = options[1]
        if options[0] == "~"
          operator = "LIKE"
        end
        "data->>'#{field}' #{operator} '#{value.gsub("\\", "").gsub("'", "''")}'"
      end.join(' AND ')
    end

    def canonical
      return nil unless valid?
      filters = []
      @pairs.sort_by { |k, v| k }.map do |field, value|
        filters.push "#{field} #{value[0]} \"#{value[1].gsub("\"", "&quote;")}\""
      end
      filters.join(' ')
    end

    private

    def build
      @build ||= begin
        query_string = @query_string.dup
        matches = query_string.scan(/(?<all>(?<field>[a-z0-9_-]+)[ ]*(?<operator>(=|~))[ ]*(?<quote>['"])(?<value>.*?)\k<quote>)/i)
        matches.each do |match|
          @pairs[match[1]] = [match[2], match[4]] if match[4]
          query_string.gsub! match[0], ''
        end
        matches = query_string.scan(/(?<field>[a-z0-9_-]+)[ ]*(?<operator>(=|~))[ ]*(?<value>[^\s'"]+)/i)
        matches.each do |match|
          @pairs[match[0]] = [match[1], match[2]] if match[2]
        end
        @pairs.each do |field, options|
          options[1] << "%" if options[0] === '~' && options[1].index('%') === nil
        end
        true
      end
    end

  end

end
