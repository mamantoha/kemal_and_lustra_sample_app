require "../../config/config"

if p = Post.find(1)
  puts p.tags.count
  puts p.dependencies.map(&.id)
  # puts p.dependents.count
end
