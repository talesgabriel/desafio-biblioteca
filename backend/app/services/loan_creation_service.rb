class LoanCreationService
  Result = Struct.new(:success?, :loan, :error)

  def self.call(...)
    new(...).call
  end

  def initialize(book:, library_user:, loan_password:, librarian:)
    @book = book
    @library_user = library_user
    @loan_password = loan_password
    @librarian = librarian
  end

  def call
    return failure("Livro não está disponível para empréstimo.") unless @book.available?
    unless @library_user.authenticate_loan_password(@loan_password)
      return failure("Senha de empréstimo inválida.")
    end

    loan = nil
    ActiveRecord::Base.transaction do
      loan_date = Date.current
      loan = Loan.create!(
        book: @book,
        library_user: @library_user,
        librarian: @librarian,
        loan_date: loan_date,
        due_date: BusinessDays.add(loan_date, Loan::LOAN_PERIOD_BUSINESS_DAYS),
        status: :active
      )
      @book.update!(status: :borrowed)
    end
    Result.new(true, loan, nil)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages.to_sentence)
  end

  private

  def failure(message)
    Result.new(false, nil, message)
  end
end
