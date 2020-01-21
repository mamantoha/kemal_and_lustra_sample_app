h1
  | Kemal and Clear Sample Application

h2 #{posts.count} posts

table
  thead
    tr
      td Title
      td Content
      td Author
      td Tags
      td Dependencies
      td Used by
  tbody
    - posts.each do |post|
      tr
        td= post.title
        td= post.content
        td= post.author.name
        td= post.tags.map(&.name).join(", ")
        td= post.dependencies.map(&.title).join(", ")
        td= post.dependents.map(&.title).join(", ")

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
