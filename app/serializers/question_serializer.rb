class QuestionSerializer < ApplicationSerializer
  attributes :id, :title, :body, :created_at, :updated_at

  belongs_to :user
end
