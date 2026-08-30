class Post
  include Lustra::Model

  primary_key

  column title : String
  column content : String?
  column kind : String

  timestamps

  full_text_searchable "tsv", catalog: "pg_catalog.simple"

  belongs_to author : Author, counter_cache: true
  has_many tags : Tag, through: PostTag

  has_many dependencies : Post, through: Relationship, foreign_key: "follower_id", own_key: "leader_id"
  has_many dependents : Post, through: Relationship, foreign_key: "leader_id", own_key: "follower_id"
end
