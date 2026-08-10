require "rails_helper"

RSpec.describe Category, type: :model do
  it "requires a name" do
    category = Category.new(name: "")
    expect(category).not_to be_valid
  end

  it "requires a unique name" do
    Category.create!(name: "História")
    duplicate = Category.new(name: "História")

    expect(duplicate).not_to be_valid
  end

  it "cannot be destroyed while it has books" do
    category = Category.create!(name: "História")
    Book.create!(title: "Livro", author: "Autor", category: category)

    expect(category.destroy).to be_falsey
    expect(Category.exists?(category.id)).to be true
  end
end
