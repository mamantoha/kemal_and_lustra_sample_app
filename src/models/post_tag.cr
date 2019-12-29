class PostTag
  include Clear::Model

  belongs_to post : Post
  belongs_to tag : Tag
end
