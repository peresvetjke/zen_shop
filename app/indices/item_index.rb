ThinkingSphinx::Index.define :item, :with => :real_time do
  # fields
  indexes title, :sortable => true
  indexes description
  indexes price, :sortable => true

  # attributes
  # has created_at, :type => :timestamp
  # has updated_at, :type => :timestamp
end