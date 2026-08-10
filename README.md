# Biblioteca Municipal Ney Pontes

Sistema web para gerenciamento do acervo, usuários e empréstimos da Biblioteca Municipal Ney Pontes, desenvolvido para o **Desafio Nº 0001/2026 da Prefeitura de Mossoró/RN**.

## Funcionalidades

- Login e logout de bibliotecários
- Cadastro de bibliotecários
- Troca obrigatória de senha no primeiro acesso
- Recuperação de senha por e-mail
- Cadastro e gerenciamento de categorias
- Cadastro e gerenciamento de livros
- Cadastro e gerenciamento de usuários da biblioteca
- Geração automática de senha de empréstimo
- Envio da senha de empréstimo por e-mail
- Registro e devolução de empréstimos
- Prazo de empréstimo de 15 dias úteis
- Relatório de livros em atraso
- Dashboard com indicadores do sistema

## Tecnologias

- Ruby 3.4
- Ruby on Rails 8
- PostgreSQL
- Active Record
- React
- Vite
- RSpec
- RuboCop
- Action Mailer

## Requisitos

- Ruby 3.4+
- Rails 8+
- Node.js 22+
- PostgreSQL
- Bundler

## Setup rápido

### Backend

```bash
cd backend
bundle install
cp .env.example .env
bin/rails db:create db:migrate db:seed
bin/rails server
```

Backend disponível em:

```text
http://localhost:3000
```

### Frontend

Em outro terminal:

```bash
cd frontend
npm install
cp .env.example .env
npm run dev
```

Frontend disponível em:

```text
http://localhost:5173
```

## Credenciais

### Administrador

| Campo | Valor |
|---|---|
| E-mail | `admin@mossoro.rn.gov.br` |
| Senha | `Admin@123` |

### Bibliotecário com primeiro acesso

| Campo | Valor |
|---|---|
| E-mail | `novo.bibliotecario@mossoro.rn.gov.br` |
| Senha | `Provisoria@123` |

As credenciais acima são criadas pelo `db:seed` e destinadas à demonstração do sistema.

## E-mails

O sistema utiliza o **Action Mailer** para:

- Enviar a senha de empréstimo ao cadastrar um usuário;
- Enviar links para recuperação de senha.

As configurações de SMTP são definidas através das variáveis de ambiente.

## API

### Autenticação

| Método | Rota | Descrição |
|---|---|---|
| POST | `/api/login` | Login |
| DELETE | `/api/logout` | Logout |
| GET | `/api/me` | Dados do usuário autenticado |
| POST | `/api/password/forgot` | Solicitar recuperação de senha |
| POST | `/api/password/reset` | Redefinir senha |
| PATCH | `/api/password/change` | Alterar senha |

### Bibliotecários

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/librarians` | Listar bibliotecários |
| POST | `/api/librarians` | Cadastrar bibliotecário |

### Categorias

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/categories` | Listar categorias |
| POST | `/api/categories` | Cadastrar categoria |
| PATCH | `/api/categories/:id` | Editar categoria |
| DELETE | `/api/categories/:id` | Excluir categoria |

### Livros

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/books` | Listar livros |
| POST | `/api/books` | Cadastrar livro |
| PATCH | `/api/books/:id` | Editar livro |
| DELETE | `/api/books/:id` | Excluir livro |

### Usuários da biblioteca

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/library_users` | Listar usuários |
| POST | `/api/library_users` | Cadastrar usuário |
| PATCH | `/api/library_users/:id` | Editar usuário |
| DELETE | `/api/library_users/:id` | Excluir usuário |

### Empréstimos

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/loans` | Listar empréstimos |
| POST | `/api/loans` | Registrar empréstimo |
| GET | `/api/loans/:id` | Consultar empréstimo |
| PATCH | `/api/loans/:id/return` | Registrar devolução |
| GET | `/api/loans/overdue` | Listar empréstimos em atraso |

### Dashboard

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/dashboard` | Indicadores do sistema |

## Variáveis de ambiente

Copie o arquivo `.env.example`:

```bash
cp .env.example .env
```

### Backend

Principais variáveis:

```env
DB_USERNAME=
DB_PASSWORD=
DB_HOST=localhost
DB_PORT=5432

SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=
SMTP_PASSWORD=
MAILER_FROM=
```

### Frontend

```env
VITE_API_URL=http://localhost:3000/api
```