class GraphController < ApplicationController
  def index
  end

  def data
    render json: GraphData.new(Key.all), current_key:
  end
end
