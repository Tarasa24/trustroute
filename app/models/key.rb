# frozen_string_literal: true

# Key model
class Key
  include ActiveGraph::Node

  property :key_id, type: Integer
  property :master, type: Boolean, default: false

  validates :key_id, presence: true, uniqueness: true
end
