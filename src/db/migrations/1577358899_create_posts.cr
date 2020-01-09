class CreatePosts
  include Clear::Migration

  def change(direction)
    direction.up do
      create_table(:authors) do |t|
        t.column :name, :string, index: true

        t.timestamps
      end

      create_table(:posts) do |t|
        t.column :title, :string, index: true
        t.column :content, :string, unique: true

        t.column :tsv, "tsvector"

        t.index :tsv, using: :gin

        t.references to: "authors", name: "author_id", on_delete: "cascade", null: false, primary: true

        t.timestamps
      end

      create_table(:tags) do |t|
        t.column :name, :string, index: true, unique: true, null: false

        t.timestamps
      end

      create_table(:post_tags, id: false) do |t|
        t.references to: "tags", name: "tag_id", on_delete: "cascade", null: false, primary: true
        t.references to: "posts", name: "post_id", on_delete: "cascade", null: false, primary: true

        t.index ["tag_id", "post_id"], using: :btree, unique: true
      end

      create_table(:relationships, id: false) do |t|
        t.references to: "posts", name: "leader_id", on_delete: "cascade", null: false, primary: true
        t.references to: "posts", name: "follower_id", on_delete: "cascade", null: false, primary: true

        t.index ["leader_id", "follower_id"], using: :btree, unique: true
      end

      #
      # Creates function triggers
      #
      execute <<-SQL
        CREATE OR REPLACE FUNCTION tsv_trigger_insert_posts() RETURNS trigger AS $$
        begin
          new.tsv :=
            setweight(to_tsvector('pg_catalog.simple', coalesce(new.title, '')), 'A') ||
            setweight(to_tsvector('pg_catalog.simple', coalesce(new.content, '')), 'B');
          return new;
        end
        $$ LANGUAGE plpgsql;
      SQL

      execute <<-SQL
        CREATE OR REPLACE FUNCTION tsv_trigger_update_posts() RETURNS trigger AS $$
        begin
          SELECT setweight(to_tsvector('pg_catalog.simple', coalesce(title, '')), 'A') ||
                 setweight(to_tsvector('pg_catalog.simple', coalesce(content, '')), 'B') ||
                 setweight(to_tsvector('pg_catalog.simple', coalesce(authors.name, '')), 'C') ||
                 setweight(to_tsvector('pg_catalog.simple', coalesce((string_agg(tags.name, ' ')), '')), 'B')
            INTO new.tsv
            FROM posts
            JOIN authors ON authors.id = posts.author_id
            LEFT JOIN post_tags ON post_tags.post_id = posts.id
            LEFT JOIN tags ON tags.id = post_tags.tag_id
            WHERE posts.id = new.id
            GROUP BY posts.id, authors.id;
          return new;
        end
        $$ LANGUAGE plpgsql;
      SQL

      #
      # Creates triggers
      #
      execute <<-SQL
        CREATE TRIGGER tsv_update_posts BEFORE UPDATE
          ON posts
          FOR EACH ROW
          EXECUTE PROCEDURE tsv_trigger_update_posts();
      SQL

      execute <<-SQL
        CREATE TRIGGER tsv_insert_posts BEFORE INSERT
          ON posts
          FOR EACH ROW
          EXECUTE PROCEDURE tsv_trigger_insert_posts();
      SQL
    end

    direction.down do
      execute("DROP TABLE authors")
      execute("DROP TABLE posts")
      execute("DROP TABLE tags")
      execute("DROP TABLE post_tags")
      execute("DROP FUNCTION tsv_trigger_insert_posts()")
      execute("DROP FUNCTION tsv_trigger_update_posts()")
      execute("DROP TRIGGER tsv_update_posts}")
      execute("DROP TRIGGER tsv_insert_posts}")
    end
  end
end
