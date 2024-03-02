class ForceCreateEmailIdentityUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :EmailIdentity, :uuid, force: true
  end

  def down
    drop_constraint :EmailIdentity, :uuid
  end
end
