# frozen_string_literal: true

# PORO to represent graph data
# It ensures that provided keys have their corresponding links
# @see GraphDataSerializer
class GraphData < ActiveModelSerializers::Model
  def initialize(keys)
    @keys = keys
    super()
  end

  def nodes
    @keys
  end

  def links
    []
  end
end
