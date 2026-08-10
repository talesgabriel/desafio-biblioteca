class Book < ApplicationRecord
  belongs_to :category
  has_many :loans, dependent: :restrict_with_error

  enum :status, { available: 0, borrowed: 1 }, default: :available

  validates :title, presence: true
  validates :author, presence: true

  scope :search, ->(query) {
    where("title ILIKE :q OR author ILIKE :q", q: "%#{sanitize_sql_like(query)}%")
  }
end
