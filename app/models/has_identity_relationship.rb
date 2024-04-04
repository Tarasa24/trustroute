class HasIdentityRelationship
  include ActiveGraph::Relationship

  type "has_identity"

  from_class :Key
  to_class %i[OAuthIdentity EmailIdentity DNSIdentity]
end
