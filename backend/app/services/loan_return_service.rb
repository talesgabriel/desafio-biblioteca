class LoanReturnService
  Result = Struct.new(:success?, :loan, :error)

  def self.call(...)
    new(...).call
  end

  def initialize(loan:)
    @loan = loan
  end

  def call
    return failure("Empréstimo já foi devolvido.") unless @loan.active?

    ActiveRecord::Base.transaction do
      @loan.update!(status: :returned, return_date: Date.current)
      @loan.book.update!(status: :available)
    end
    Result.new(true, @loan, nil)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages.to_sentence)
  end

  private

  def failure(message)
    Result.new(false, nil, message)
  end
end
