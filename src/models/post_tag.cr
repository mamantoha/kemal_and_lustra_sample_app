class PostTag
  include Lustra::Model

  belongs_to post : Post
  belongs_to tag : Tag
end
