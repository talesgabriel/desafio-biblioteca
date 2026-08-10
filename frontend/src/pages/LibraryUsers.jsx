import { useEffect, useState } from "react";
import { libraryUsers } from "../api/resources";
import Alert from "../components/Alert";

const emptyForm = { full_name: "", cpf: "", phone: "", email: "" };

export default function LibraryUsers() {
  const [items, setItems] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [editingId, setEditingId] = useState(null);
  const [query, setQuery] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const load = async () => setItems(await libraryUsers.list({ query }));

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query]);

  const resetForm = () => {
    setForm(emptyForm);
    setEditingId(null);
  };

  const handleChange = (field) => (event) => setForm({ ...form, [field]: event.target.value });

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setMessage("");
    setLoading(true);
    try {
      if (editingId) {
        await libraryUsers.update(editingId, form);
      } else {
        await libraryUsers.create(form);
        setMessage("Usuário cadastrado. A senha de empréstimo foi enviada por e-mail.");
      }
      resetForm();
      await load();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (user) => {
    setEditingId(user.id);
    setForm({ full_name: user.full_name, cpf: user.cpf, phone: user.phone, email: user.email });
  };

  const handleDelete = async (user) => {
    if (!window.confirm(`Excluir o usuário "${user.full_name}"?`)) return;
    setError("");
    try {
      await libraryUsers.remove(user.id);
      await load();
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div>
      <h1>Usuários da biblioteca</h1>
      <Alert>{error}</Alert>
      <Alert type="success">{message}</Alert>

      <form className="card-form" onSubmit={handleSubmit}>
        <div className="form-grid">
          <label>
            Nome completo
            <input value={form.full_name} onChange={handleChange("full_name")} required />
          </label>
          <label>
            CPF
            <input value={form.cpf} onChange={handleChange("cpf")} required disabled={!!editingId} />
          </label>
          <label>
            Telefone
            <input value={form.phone} onChange={handleChange("phone")} required />
          </label>
          <label>
            E-mail
            <input type="email" value={form.email} onChange={handleChange("email")} required />
          </label>
        </div>
        {!editingId && (
          <p className="hint">
            A senha de empréstimo é gerada automaticamente e enviada para o e-mail informado.
          </p>
        )}
        <div className="form-actions">
          <button type="submit" disabled={loading}>
            {editingId ? "Salvar alterações" : "Cadastrar usuário"}
          </button>
          {editingId && (
            <button type="button" className="secondary" onClick={resetForm}>
              Cancelar
            </button>
          )}
        </div>
      </form>

      <input
        className="search-input"
        placeholder="Buscar por nome ou CPF"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />

      <table className="data-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>CPF</th>
            <th>Telefone</th>
            <th>E-mail</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {items.map((user) => (
            <tr key={user.id}>
              <td>{user.full_name}</td>
              <td>{user.cpf}</td>
              <td>{user.phone}</td>
              <td>{user.email}</td>
              <td className="actions">
                <button type="button" onClick={() => handleEdit(user)}>
                  Editar
                </button>
                <button type="button" className="danger" onClick={() => handleDelete(user)}>
                  Excluir
                </button>
              </td>
            </tr>
          ))}
          {items.length === 0 && (
            <tr>
              <td colSpan={5} className="empty">
                Nenhum usuário encontrado.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
