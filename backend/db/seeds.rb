# Demo data for presenting the Biblioteca Municipal Ney Pontes system.
# Safe to run multiple times (idempotent via find_or_create_by!).

admin = Librarian.find_or_create_by!(email: "admin@mossoro.rn.gov.br") do |librarian|
  librarian.name = "Admin da Biblioteca"
  librarian.password = "Admin@123"
  librarian.must_change_password = false
end

Librarian.find_or_create_by!(email: "novo.bibliotecario@mossoro.rn.gov.br") do |librarian|
  librarian.name = "Bibliotecário Novo"
  librarian.password = "Provisoria@123"
  librarian.must_change_password = true
end

categories = [ "Literatura Brasileira", "História", "Ciências", "Infantil", "Poesia" ].map do |name|
  Category.find_or_create_by!(name: name)
end

books = [
  { title: "Dom Casmurro", author: "Machado de Assis", category: categories[0] },
  { title: "Memórias Póstumas de Brás Cubas", author: "Machado de Assis", category: categories[0] },
  { title: "História de Mossoró", author: "Raimundo Nonato", category: categories[1] },
  { title: "Uma Breve História do Tempo", author: "Stephen Hawking", category: categories[2] },
  { title: "O Pequeno Príncipe", author: "Antoine de Saint-Exupéry", category: categories[3] },
  { title: "Poemas Escolhidos", author: "Carlos Drummond de Andrade", category: categories[4] }
]

books.each do |attrs|
  Book.find_or_create_by!(title: attrs[:title], author: attrs[:author]) do |book|
    book.category = attrs[:category]
    book.status = :available
  end
end

unless LibraryUser.exists?(cpf: "12345678900")
  LibraryUserRegistrationService.call(
    attributes: {
      full_name: "Maria da Silva",
      cpf: "12345678900",
      phone: "(84) 99999-0000",
      email: "maria.silva@example.com"
    }
  )
end

puts "Seed concluída."
puts "Login admin: #{admin.email} / senha: Admin@123"
puts "Login com troca obrigatória: novo.bibliotecario@mossoro.rn.gov.br / senha: Provisoria@123"
