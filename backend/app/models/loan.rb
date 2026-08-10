class Loan < ApplicationRecord
  LOAN_PERIOD_BUSINESS_DAYS = 15

  belongs_to :book
  belongs_to :library_user
  belongs_to :librarian

  enum :status, { active: 0, returned: 1 }, default: :active

  validates :loan_date, presence: true
  validates :due_date, presence: true

  scope :overdue, -> { active.where(due_date: ...Date.current) }

  def overdue?
    active? && due_date < Date.current
  end
end
