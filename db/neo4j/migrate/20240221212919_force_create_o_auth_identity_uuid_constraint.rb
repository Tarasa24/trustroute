class ForceCreateOAuthIdentityUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :OAuthIdentity, :uuid, force: true
  end

  def down
    drop_constraint :OAuthIdentity, :uuid
  end
end
