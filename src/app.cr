require "kemal"
require "./ext/kemal"
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
      "COUNT(post_tags.*) AS tagging_count"
    )

  render "src/views/index.slang"
end

get "/tags/:name" do |env|
  name = env.params.url["name"]

  if tag = Tag.query.find({name: name})
    posts = tag.posts.with_tags.with_author

    render "src/views/tags.slang"
  else
    raise Kemal::Exceptions::RouteNotFound.new(env)
  end
end

get "/authors/:id" do |env|
  author_id = env.params.url["id"].to_i

  if author = Author.find(author_id)
    posts = author.posts.with_tags.with_author

    render "src/views/author.slang"
  else
    raise Kemal::Exceptions::RouteNotFound.new(env)
  end
end

Kemal.run
