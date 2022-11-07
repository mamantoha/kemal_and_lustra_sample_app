class AddKindToPosts
  include Clear::Migration

  def change(dir)
    direction.up do
      add_column "posts", "kind", "text"
    end

    direction.down do
      add_column "posts", "kind", "text"
    end
  end
end
