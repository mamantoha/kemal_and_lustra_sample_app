h1 #{posts.count} posts

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
