class CommentSerializer < ApplicationSerializer
  attributes :id, :text, :created_at, :updated_at, :commentable_type, :commentable_id
end
