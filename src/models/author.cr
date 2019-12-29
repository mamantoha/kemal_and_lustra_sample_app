class Author
  include Clear::Model

  primary_key

  column name : String

  timestamps

  has_many posts : Post
end
