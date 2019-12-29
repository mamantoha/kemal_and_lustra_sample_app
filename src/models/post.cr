class Post
  include Clear::Model

  primary_key

  column title : String
  column content : String

  timestamps

  full_text_searchable "tsv", catalog: "pg_catalog.simple"

  belongs_to author : Author
  has_many tags : Tag, through: PostTag

  def touch
    now = Time.local

    self.updated_at = Time.local
    self.save
  end
end
