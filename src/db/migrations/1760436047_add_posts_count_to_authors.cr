class AddPostsCountToAuthors
  include Lustra::Migration

  def change(dir)
    add_column "authors", "posts_count", :integer, nullable: false, default: "0"

    # dir.up do
    #   add_column "authors", "posts_count", :integer, nullable: false, default: "0"
    # end

    # dir.down do
    #   add_column "authors", "posts_count", :integer
    # end
  end
end
