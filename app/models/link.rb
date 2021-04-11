class Link < ApplicationRecord
  GIST_HOST = 'gist.github.com'.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist_id
    uri.path.split('/').last if gist?
  end

  def gist?
    uri.host == GIST_HOST
  end

  private

  def uri
    @uri ||= URI(url)
  end
end
