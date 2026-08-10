import { useEffect, useState } from "react";
import { dashboard } from "../api/resources";
import Alert from "../components/Alert";

const cards = [
  { key: "total_books", label: "Livros no acervo" },
  { key: "available_books", label: "Livros disponíveis" },
  { key: "borrowed_books", label: "Livros emprestados" },
  { key: "total_library_users", label: "Usuários cadastrados" },
  { key: "active_loans", label: "Empréstimos ativos" },
  { key: "overdue_loans", label: "Empréstimos atrasados" },
];

export default function Dashboard() {
  const [summary, setSummary] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    dashboard
      .summary()
      .then(setSummary)
      .catch((err) => setError(err.message));
  }, []);

  return (
    <div>
      <h1>Painel geral</h1>
      <Alert>{error}</Alert>
      <div className="cards-grid">
        {cards.map((card) => (
          <div key={card.key} className="stat-card">
            <span className="stat-value">{summary ? summary[card.key] : "—"}</span>
            <span className="stat-label">{card.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
