class CreateAdmins
  include Clear::Migration

  def change(direction)
    direction.up do
      create_table(:admins) do |t|
        t.column :name, :string, index: true

        t.timestamps
      end
    end

    direction.down do
      execute("DROP TABLE admins")
    end
  end
end
