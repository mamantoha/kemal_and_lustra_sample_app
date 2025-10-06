Lustra.seed do
  a1 = Author.create!({name: "John"})
  a2 = Author.create!({name: "Jane"})

  p1 = Post.create!({
    title:   "About poney",
    content: "Poney are cool",
    author:  a1,
    kind:    "test",
  })
  p2 = Post.create!({
    title:   "About dog and cat",
    content: "Cat and dog are cool. But not as much as poney",
    author:  a1,
    kind:    "test",
  })
  p3 = Post.create!({
    title:   "You won't believe: She raises her poney like as star!",
    content: "She's col because poney are cool",
    author:  a2,
    kind:    "test",
  })
  p4 = Post.create!({
    title:   "Post without tags",
    content: "Test posts without tags",
    author:  a2,
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
