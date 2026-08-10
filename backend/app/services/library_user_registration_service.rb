class LibraryUserRegistrationService
  Result = Struct.new(:success?, :library_user, :error)

  def self.call(...)
    new(...).call
  end

  def initialize(attributes:)
    @attributes = attributes
  end

  def call
    loan_password = SecureRandom.alphanumeric(8)
    library_user = LibraryUser.new(@attributes.merge(loan_password: loan_password))

    if library_user.save
      LibraryUserMailer.loan_password(library_user, loan_password).deliver_now
      Result.new(true, library_user, nil)
    else
      Result.new(false, nil, library_user.errors.full_messages.to_sentence)
    end
  end
end
