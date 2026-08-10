class LibrarianRegistrationService
  Result = Struct.new(:success?, :librarian, :error)

  def self.call(...)
    new(...).call
  end
  
  def initialize(attributes:)
    @attributes = attributes
  end

  def call
    librarian = Librarian.new(@attributes.merge(must_change_password: true))

    if librarian.save
      Result.new(true, librarian, nil)
    else
      Result.new(false, nil, librarian.errors.full_messages.to_sentence)
    end
  end
end
