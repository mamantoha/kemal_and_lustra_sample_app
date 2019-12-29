h1 #{posts.count} posts

table
  thead
    tr
      td Title
      td Content
      td Author
      td Tags
  tbody
    - posts.each do |post|
      tr
        td= post.title
        td= post.content
        td= post.author.name
        td= post.tags.map(&.name).join(", ")
