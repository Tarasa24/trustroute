class GraphDataSerializer < ActiveModel::Serializer
  has_many :nodes, serializer: KeySerializer
  has_many :links
end
