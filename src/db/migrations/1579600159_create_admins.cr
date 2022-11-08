class CreateAdmins
  include Clear::Migration

  def change(dir)
    dir.up do
      create_table(:admins) do |t|
        t.column :name, :string, index: true

        t.timestamps
      end
    end

    dir.down do
      execute("DROP TABLE admins")
    end
  end
end
