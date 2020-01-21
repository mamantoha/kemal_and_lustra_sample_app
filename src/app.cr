require "kemal"
require "kilt/slang"
require "../config/config"

get "/" do |env|
  query = env.params.query["query"]?

  posts =
    if query
      Post.query.with_tags.with_author.search(query)
    else
      Post.query.with_tags.with_author
    end

  authors = Author.query

  taggings = Tag
    .query
    .join("post_tags") { post_tags.tag_id == tags.id }
    .group_by("tags.id")
    .order_by(tagging_count: :desc)
    .select(
      "tags.*",
      "COUNT(repository_tags.*) AS tagging_count"
    )

  render "src/views/index.slang"
end

Kemal.run
