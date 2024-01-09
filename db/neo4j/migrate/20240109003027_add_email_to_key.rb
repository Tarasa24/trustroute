class AddEmailToKey < ActiveGraph::Migrations::Base
  def up
    add_constraint :Key, :email
  end

  def down
    drop_constraint :Key, :email
  end
end
