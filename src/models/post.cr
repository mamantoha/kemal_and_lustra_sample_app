class Post
  include Clear::Model

  primary_key

  column title : String
  column content : String
  column kind : String

  timestamps

  full_text_searchable "tsv", catalog: "pg_catalog.simple"

  belongs_to author : Author

  has_many post_tags : PostTag, foreign_key: "post_id"
  has_many tags : Tag, through: :post_tags, relation: :tag

  has_many relationships : Relationship
  has_many dependencies : Post, through: :relationships, relation: :leader
  has_many dependents : Post, through: :relationships, relation: :follower

  def tags=(names : Array(String))
    names.map do |name|
      tag = Tag.query.find_or_create(name: name) { }
      self.tags << tag
    end

    unlink_tags = tag_names - names
    unlink_tags.each do |name|
      if tag = Tag.query.find!({name: name})
        self.tags.unlink(tag)
      end
    end
  end

  def tag_names
    self.tags.map(&.name)
  end

  def touch
    now = Time.local

    self.updated_at = Time.local
    self.save
  end
end
