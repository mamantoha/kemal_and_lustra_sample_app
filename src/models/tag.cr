class Tag
  include Lustra::Model

  primary_key

  column name : String

  timestamps

  has_many posts : Post, through: PostTag
end
