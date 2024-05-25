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
    return render json: [] if result.nil?

    shortest_path = result["path"].map do |segment|
      {
        from: segment.start_node[:uuid],
        to: segment.end_node[:uuid]
      }
    end

    render json: shortest_path
  end

  def search
    @query = params[:query]
    begin
      @results = Key.search(@query).first(20)
    rescue 
      @results = []
    end
  end
end
