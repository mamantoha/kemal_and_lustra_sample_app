h1
  | Kemal and Clear Sample Application

h2 #{posts.count} posts

== render "src/views/partials/posts.slang"

h2 #{authors.count} authors

table
  thead
    tr
      td Name
      td Posts
  tbody
    - authors.each do |author|
      tr
        td= author.name
        td= author.posts.map(&.title).join(", ")

h2 #{taggings.count} tags

table
  thead
    tr
      td Name
      td Posts
      td Tagged times
  tbody
    - taggings.each(fetch_columns: true) do |tag|
      tr
        td= tag.name
        td= tag.posts.map(&.title).join(", ")
        td= tag.attributes["tagging_count"]
