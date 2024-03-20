class GraphController < ApplicationController
  def index
  end

  def data
    render json: GraphData.new(Key.all)
  end

  def path
    return render json: [] if params[:from] == params[:to]

    query = <<-CYPHER
      MATCH (from:Key {uuid: $from}), (to:Key {uuid: $to}),
      path = shortestPath((from)-[:vouches_for*]-(to))
      RETURN path
    CYPHER

    result = ActiveGraph::Base.query(query, from: params[:from], to: params[:to]).to_a.first
    shortest_path = result["path"].map do |segment|
      {
        source: segment.start_node[:uuid],
        target: segment.end_node[:uuid]
      }
    end

    render json: shortest_path
  end
end
