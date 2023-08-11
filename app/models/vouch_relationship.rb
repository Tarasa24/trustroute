# frozen_string_literal: true

# Who vouches for whom and with what signature?
class VouchRelationship
  include ActiveGraph::Relationship

  type 'vouches_for'

  from_class :Key
  to_class   :Key

  property :signature_id, type: Integer

  validates :signature_id, presence: true
end
