class Post
  include Lustra::Model

  primary_key

  column title : String
  column content : String
  column kind : String

  timestamps

  full_text_searchable "tsv", catalog: "pg_catalog.simple"

  belongs_to author : Author, counter_cache: true
  has_many tags : Tag, through: PostTag

  has_many dependencies : Post, through: Relationship, foreign_key: "follower_id", own_key: "leader_id"
  has_many dependents : Post, through: Relationship, foreign_key: "leader_id", own_key: "follower_id"

  def tags=(names : Array(String))
    names.map do |name|
      tag = Tag.query.find_or_create(name: name)
      tags << tag
    end

    unlink_tags = tag_names - names
    unlink_tags.each do |name|
      if tag = Tag.find_by!(name: name)
        tags.unlink(tag)
      end
    end
  end

  def tag_names
    tags.map(&.name)
  end
end
