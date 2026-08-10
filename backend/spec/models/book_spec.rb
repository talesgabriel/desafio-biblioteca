require "rails_helper"

RSpec.describe Book, type: :model do
  let(:category) { Category.create!(name: "Literatura") }

  it "is valid with title, author and category" do
    book = Book.new(title: "Dom Casmurro", author: "Machado de Assis", category: category)
    expect(book).to be_valid
  end

  it "requires a title" do
    book = Book.new(author: "Machado de Assis", category: category)
    expect(book).not_to be_valid
    expect(book.errors[:title]).to be_present
  end

  it "requires an author" do
    book = Book.new(title: "Dom Casmurro", category: category)
    expect(book).not_to be_valid
    expect(book.errors[:author]).to be_present
  end

  it "requires a category" do
    book = Book.new(title: "Dom Casmurro", author: "Machado de Assis")
    expect(book).not_to be_valid
    expect(book.errors[:category]).to be_present
  end

  it "defaults to available status" do
    book = Book.create!(title: "Dom Casmurro", author: "Machado de Assis", category: category)
    expect(book).to be_available
  end

  it "only accepts known status values" do
    book = Book.create!(title: "Dom Casmurro", author: "Machado de Assis", category: category)
    expect { book.status = "lost" }.to raise_error(ArgumentError)
  end
end
