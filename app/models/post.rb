class Post < ApplicationRecord
  belongs_to :user
  has_many :comment

  validates :tags, presence: true
end
