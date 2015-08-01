class QueriesController < ApplicationController

  def index
    @queries = Query.order(updated_at: :desc).limit(50)
  end

end
