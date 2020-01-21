class AddKindToPosts
  include Clear::Migration

  def change(direction)
    direction.up do
      add_column "posts", "kind", "text"
    end

    direction.down do
      drop_column "posts", "kind", "text"
    end
  end
end
