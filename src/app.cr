require "kemal"
require "kemal-kilt"
require "kilt/slang"
require "../config/config"

get "/" do |env|
  query = env.params.query["query"]?

  posts = Post.query.with_tags.with_author

  posts.search(query) if query

  authors = Author.query.with_posts

  taggings =
    Tag
      .query
      .join(:post_tags)
      .with_count(:post_tags)
      .order_by(post_tags_count: :desc)

  render "src/views/index.slang"
end

get "/tags/:name" do |env|
  name = env.params.url["name"]

  if tag = Tag.find_by(name: name)
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
