class ForceCreateDNSIdentityUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :DNSIdentity, :uuid, force: true
  end

  def down
    drop_constraint :DNSIdentity, :uuid
  end
end
