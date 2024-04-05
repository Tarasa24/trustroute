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
    @keys.map do |key|
      key.vouches_for.map do |vouch|
        { source: key.id, target: vouch.id }
      end
    end.flatten
  end
end
