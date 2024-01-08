# frozen_string_literal: true

# Who vouches for whom and with what signature?
class VouchRelationship
  include ActiveGraph::Relationship

  type "vouches_for"

  from_class :Key
  to_class :Key

  property :signature_id, type: Integer

  validates :signature_id, presence: true

  def self.between_master_keys
    query = "MATCH (from:Key)-[rel:vouches_for]->(to:Key) "
    query += "WHERE from.master = true AND to.master = true "
    query += "RETURN from, rel, to"

    ActiveGraph::Base.query(query)
  end
end
