class User < ApplicationRecord
    has_secure_password
    has_many :post
    has_many :comment

   # validates :email, presence: true, uniqueness: true
end
