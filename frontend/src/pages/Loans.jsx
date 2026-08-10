import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { books, libraryUsers, loans } from "../api/resources";
import Alert from "../components/Alert";

export default function Loans() {
  const [bookQuery, setBookQuery] = useState("");
  const [bookResults, setBookResults] = useState([]);
  const [selectedBook, setSelectedBook] = useState(null);

  const [cpfQuery, setCpfQuery] = useState("");
  const [userResult, setUserResult] = useState(null);
  const [userSearched, setUserSearched] = useState(false);

  const [loanPassword, setLoanPassword] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const [activeLoans, setActiveLoans] = useState([]);
  const [overdueLoans, setOverdueLoans] = useState([]);

  const loadLoans = async () => {
    setActiveLoans(await loans.list({ status: "active" }));
    setOverdueLoans(await loans.overdue());
  };

  useEffect(() => {
    loadLoans();
  }, []);

  const searchBooks = async (event) => {
    event.preventDefault();
    setBookResults(await books.list({ query: bookQuery, status: "available" }));
  };

  const searchUser = async (event) => {
    event.preventDefault();
    setUserSearched(true);
    const results = await libraryUsers.list({ cpf: cpfQuery });
    setUserResult(results[0] || null);
  };

  const resetLoanForm = () => {
    setSelectedBook(null);
    setBookQuery("");
    setBookResults([]);
    setCpfQuery("");
    setUserResult(null);
    setUserSearched(false);
    setLoanPassword("");
  };

  const handleCreateLoan = async (event) => {
    event.preventDefault();
    setError("");
    setMessage("");
    setLoading(true);
    try {
      await loans.create({
        book_id: selectedBook.id,
        library_user_id: userResult.id,
        loan_password: loanPassword,
      });
      setMessage(`Empréstimo registrado para "${selectedBook.title}".`);
      resetLoanForm();
      await loadLoans();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleReturn = async (loan) => {
    if (!window.confirm(`Confirmar devolução de "${loan.book.title}"?`)) return;
    setError("");
    try {
      await loans.returnLoan(loan.id);
      await loadLoans();
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div>
      <h1>Empréstimos</h1>
      <Alert>{error}</Alert>
      <Alert type="success">{message}</Alert>

      <section className="panel">
        <h2>Novo empréstimo</h2>

        <div className="loan-step">
          <strong>1. Livro</strong>
          {selectedBook ? (
            <div className="selected-row">
              <span>
                {selectedBook.title} — {selectedBook.author}
              </span>
              <button type="button" className="secondary" onClick={() => setSelectedBook(null)}>
                Trocar
              </button>
            </div>
          ) : (
            <>
              <form className="inline-form" onSubmit={searchBooks}>
                <input
                  placeholder="Buscar livro disponível por título ou autor"
                  value={bookQuery}
                  onChange={(e) => setBookQuery(e.target.value)}
                />
                <button type="submit">Buscar</button>
              </form>
              <ul className="result-list">
                {bookResults.map((book) => (
                  <li key={book.id}>
                    <span>
                      {book.title} — {book.author}
                    </span>
                    <button type="button" onClick={() => setSelectedBook(book)}>
                      Selecionar
                    </button>
                  </li>
                ))}
                {bookResults.length === 0 && bookQuery && (
                  <li className="empty">Nenhum livro disponível encontrado.</li>
                )}
              </ul>
            </>
          )}
        </div>

        {selectedBook && (
          <div className="loan-step">
            <strong>2. Usuário da biblioteca</strong>
            {userResult ? (
              <div className="selected-row">
                <span>
                  {userResult.full_name} — CPF {userResult.cpf}
                </span>
                <button
                  type="button"
                  className="secondary"
                  onClick={() => {
                    setUserResult(null);
                    setUserSearched(false);
                  }}
                >
                  Trocar
                </button>
              </div>
            ) : (
              <>
                <form className="inline-form" onSubmit={searchUser}>
                  <input
                    placeholder="CPF do usuário"
                    value={cpfQuery}
                    onChange={(e) => setCpfQuery(e.target.value)}
                    required
                  />
                  <button type="submit">Buscar</button>
                </form>
                {userSearched && !userResult && (
                  <p className="hint">
                    Usuário não encontrado. <Link to="/usuarios">Cadastre-o</Link> antes de continuar o
                    empréstimo.
                  </p>
                )}
              </>
            )}
          </div>
        )}

        {selectedBook && userResult && (
          <form className="loan-step inline-form" onSubmit={handleCreateLoan}>
            <strong>3. Senha de empréstimo</strong>
            <input
              type="password"
              placeholder="Senha de empréstimo do usuário"
              value={loanPassword}
              onChange={(e) => setLoanPassword(e.target.value)}
              required
            />
            <button type="submit" disabled={loading}>
              {loading ? "Registrando..." : "Confirmar empréstimo"}
            </button>
          </form>
        )}
      </section>

      <section className="panel">
        <h2>Empréstimos ativos</h2>
        <table className="data-table">
          <thead>
            <tr>
              <th>Livro</th>
              <th>Usuário</th>
              <th>Empréstimo</th>
              <th>Devolução prevista</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
            {activeLoans.map((loan) => (
              <tr key={loan.id} className={new Date(loan.due_date) < new Date() ? "row-overdue" : ""}>
                <td>{loan.book.title}</td>
                <td>{loan.library_user.full_name}</td>
                <td>{loan.loan_date}</td>
                <td>{loan.due_date}</td>
                <td className="actions">
                  <button type="button" onClick={() => handleReturn(loan)}>
                    Registrar devolução
                  </button>
                </td>
              </tr>
            ))}
            {activeLoans.length === 0 && (
              <tr>
                <td colSpan={5} className="empty">
                  Nenhum empréstimo ativo.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </section>

      <section className="panel">
        <h2>Relatório de livros em atraso</h2>
        <table className="data-table">
          <thead>
            <tr>
              <th>Livro</th>
              <th>Usuário</th>
              <th>Devolução prevista</th>
            </tr>
          </thead>
          <tbody>
            {overdueLoans.map((loan) => (
              <tr key={loan.id}>
                <td>{loan.book.title}</td>
                <td>{loan.library_user.full_name}</td>
                <td>{loan.due_date}</td>
              </tr>
            ))}
            {overdueLoans.length === 0 && (
              <tr>
                <td colSpan={3} className="empty">
                  Nenhum empréstimo em atraso.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </section>
    </div>
  );
}
