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

  tags = Tag.query
  authors = Author.query

  render "src/views/index.slang"
end

Kemal.run
