ThinkingSphinx::Index.define :comment, with: :active_record do
  # fileds
  indexes text
  indexes user.email, as: :author, sortable: true

  # attributes
  has commentable_id, commentable_type, user_id, created_at, updated_at
end
