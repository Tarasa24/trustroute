# frozen_string_literal: true

# Key model
class Key
  include ActiveGraph::Node

  property :key_id, type: Integer
  property :master, type: Boolean, default: false

  validates :key_id, presence: true, uniqueness: true

  has_many :out, :vouches_for, rel_class: :VouchRelationship
  has_many :in, :is_vouched_for_by, rel_class: :VouchRelationship
end
