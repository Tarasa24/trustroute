class GraphController < ApplicationController
  include GraphHelper

  def index
    @nodes = Key.all
    @links = VouchRelationship.between_master_keys
  end
end
