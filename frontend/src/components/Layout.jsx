import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../hooks/useAuth";

const links = [
  { to: "/", label: "Painel", end: true },
  { to: "/categorias", label: "Categorias" },
  { to: "/livros", label: "Livros" },
  { to: "/usuarios", label: "Usuários" },
  { to: "/emprestimos", label: "Empréstimos" },
  { to: "/bibliotecarios", label: "Bibliotecários" },
];

export default function Layout() {
  const { librarian, logout } = useAuth();

  return (
    <div className="app-shell">
      <header className="app-header">
        <div className="brand">Biblioteca Ney Pontes</div>
        <nav>
          {links.map((link) => (
            <NavLink key={link.to} to={link.to} end={link.end}>
              {link.label}
            </NavLink>
          ))}
        </nav>
        <div className="user-menu">
          <span>{librarian?.name}</span>
          <button type="button" className="secondary" onClick={logout}>
            Sair
          </button>
        </div>
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
}
