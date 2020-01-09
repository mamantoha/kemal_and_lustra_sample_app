class Relationship
  include Clear::Model

  belongs_to leader : Post, foreign_key: "leader_id"
  belongs_to follower : Post, foreign_key: "follower_id"
end
