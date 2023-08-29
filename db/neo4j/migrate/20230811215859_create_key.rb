class CreateKey < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Key, :uuid
    add_constraint :Key, :key_id
  end

  def down
    drop_constraint :Key, :uuid
    drop_constraint :Key, :key_id
  end
end
