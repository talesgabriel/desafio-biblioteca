class Api::DashboardController < ApplicationController
  def show
    render json: {
      total_books: Book.count,
      available_books: Book.available.count,
      borrowed_books: Book.borrowed.count,
      total_library_users: LibraryUser.count,
      active_loans: Loan.active.count,
      overdue_loans: Loan.overdue.count
    }
  end
end
