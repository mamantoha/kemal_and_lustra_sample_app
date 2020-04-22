class PostTag
  include Clear::Model

  belongs_to post : Post, foreign_key: "post_id"
  belongs_to tag : Tag, foreign_key: "tag_id"
end
