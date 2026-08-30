Lustra.seed do
  a1 = Author.create!({name: "John"})
  a2 = Author.create!({name: "Jane"})
  a3 = Author.create!({name: "Tom"})

  p1 = a1.posts.create!({
    title:   "About poney",
    content: "Poney are cool",
    kind:    "test",
  })

  p2 = a1.posts.create!({
    title:   "About dog and cat",
    content: "Cat and dog are cool. But not as much as poney",
    kind:    "test",
  })

  p3 = a2.posts.create!({
    title:   "You won't believe: She raises her poney like as star!",
    content: "She's col because poney are cool",
    kind:    "test",
  })

  p4 = a2.posts.create!({
    title:   "Post without tags",
    content: "Test posts without tags",
    kind:    "test",
  })

  p1.dependencies << p2
  p1.dependencies << p4

  t1 = Tag.query.find_or_create(name: "ruby")
  t2 = Tag.query.find_or_create(name: "crystal")

  p1.tags << t1
  p2.tags << t2
  p3.tags << t1
  p3.tags << t2

  Post.query.each(&.touch)
end
