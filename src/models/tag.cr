class Tag
  include Clear::Model

  primary_key

  column name : String

  timestamps

  has_many posts : Tag, through: PostTag
end
