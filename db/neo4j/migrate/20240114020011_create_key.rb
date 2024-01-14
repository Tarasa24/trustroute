class CreateKey < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Key, :uuid # Required for neo4j
    add_constraint :Key, :fingerprint
    add_constraint :Key, :email
  end

  def down
    drop_constraint :Key, :uuid
    drop_constraint :Key, :keyprint
    drop_constraint :Key, :email
  end
end
