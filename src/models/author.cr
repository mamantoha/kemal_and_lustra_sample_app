class Author
  include Lustra::Model

  primary_key

  column name : String
  column posts_count : Int32

  timestamps

  has_many posts : Post
end
