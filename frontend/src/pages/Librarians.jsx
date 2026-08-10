import { useEffect, useState } from "react";
import { librarians } from "../api/resources";
import Alert from "../components/Alert";

const emptyForm = { name: "", email: "", password: "" };

export default function Librarians() {
  const [items, setItems] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const load = async () => setItems(await librarians.list());

  useEffect(() => {
    load();
  }, []);

  const handleChange = (field) => (event) => setForm({ ...form, [field]: event.target.value });

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setMessage("");
    setLoading(true);
    try {
      await librarians.create(form);
      setMessage(
        `Bibliotecário "${form.name}" cadastrado. Informe a senha provisória a ele — será exigida a troca no primeiro acesso.`
      );
      setForm(emptyForm);
      await load();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h1>Bibliotecários</h1>
      <Alert>{error}</Alert>
      <Alert type="success">{message}</Alert>

      <form className="card-form" onSubmit={handleSubmit}>
        <div className="form-grid">
          <label>
            Nome
            <input value={form.name} onChange={handleChange("name")} required />
          </label>
          <label>
            E-mail
            <input type="email" value={form.email} onChange={handleChange("email")} required />
          </label>
          <label>
            Senha provisória
            <input
              type="password"
              minLength={8}
              value={form.password}
              onChange={handleChange("password")}
              required
            />
          </label>
        </div>
        <p className="hint">
          O novo bibliotecário deverá trocar essa senha no primeiro acesso ao sistema.
        </p>
        <div className="form-actions">
          <button type="submit" disabled={loading}>
            {loading ? "Cadastrando..." : "Cadastrar bibliotecário"}
          </button>
        </div>
      </form>

      <table className="data-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>E-mail</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {items.map((librarian) => (
            <tr key={librarian.id}>
              <td>{librarian.name}</td>
              <td>{librarian.email}</td>
              <td>{librarian.must_change_password ? "Aguardando primeiro acesso" : "Ativo"}</td>
            </tr>
          ))}
          {items.length === 0 && (
            <tr>
              <td colSpan={3} className="empty">
                Nenhum bibliotecário cadastrado.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
