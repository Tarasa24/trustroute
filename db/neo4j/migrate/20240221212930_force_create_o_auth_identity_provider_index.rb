class ForceCreateOAuthIdentityProviderIndex < ActiveGraph::Migrations::Base
  def up
    add_index :OAuthIdentity, :provider, force: true
  end

  def down
    drop_index :OAuthIdentity, :provider
  end
end
