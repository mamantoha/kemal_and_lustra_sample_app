class Tag
  include Clear::Model

  primary_key

  column name : String

  timestamps

  has_many post_tags : PostTag, foreign_key: "post_id"
  has_many posts : Post, through: :post_tags, relation: :posts
end
