class QueryResult < ActiveRecord::Base

  belongs_to :query
  belongs_to :stream

end
