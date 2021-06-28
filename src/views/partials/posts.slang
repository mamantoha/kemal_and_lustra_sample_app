table
  thead
    tr
      td #
      td Title
      td Content
      td Author
      td Tags
      td Dependencies
      td Used by
  tbody
    - posts.to_a.each do |post|
      tr
        td= post.id
        td= post.title
        td= post.content
        td
          a href="/authors/#{post.author.id}" = post.author.name
        td
          - post.tags.to_a.each do |tag|
            a href="/tags/#{tag.name}" = tag.name

        td= post.relationships_dependencies.map(&.follower.title).join(", ")
        td= post.relationships_dependents.map(&.leader.title).join(", ")

        / FIXME: table name "posts" specified more than once
        / td= post.dependencies.map(&.title).join(", ")
        / td= post.dependents.map(&.title).join(", ")
