import { useEffect, useState } from "react";
import { books, categories } from "../api/resources";
import Alert from "../components/Alert";
import StatusBadge from "../components/StatusBadge";

const emptyForm = { title: "", author: "", category_id: "", status: "available", notes: "" };

export default function Books() {
  const [items, setItems] = useState([]);
  const [categoryOptions, setCategoryOptions] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [editingId, setEditingId] = useState(null);
  const [filters, setFilters] = useState({ query: "", category_id: "", status: "" });
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const loadCategories = async () => setCategoryOptions(await categories.list());
  const loadBooks = async () => setItems(await books.list(filters));

  useEffect(() => {
    loadCategories();
  }, []);

  useEffect(() => {
    loadBooks();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filters]);

  const resetForm = () => {
    setForm(emptyForm);
    setEditingId(null);
  };

  const handleChange = (field) => (event) => setForm({ ...form, [field]: event.target.value });
  const handleFilterChange = (field) => (event) => setFilters({ ...filters, [field]: event.target.value });

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setLoading(true);
    try {
      if (editingId) {
        await books.update(editingId, form);
      } else {
        await books.create(form);
      }
      resetForm();
      await loadBooks();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (book) => {
    setEditingId(book.id);
    setForm({
      title: book.title,
      author: book.author,
      category_id: book.category.id,
      status: book.status,
      notes: book.notes || "",
    });
  };

  const handleDelete = async (book) => {
    if (!window.confirm(`Excluir o livro "${book.title}"?`)) return;
    setError("");
    try {
      await books.remove(book.id);
      await loadBooks();
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div>
      <h1>Livros</h1>
      <Alert>{error}</Alert>

      <form className="card-form" onSubmit={handleSubmit}>
        <div className="form-grid">
          <label>
            Título
            <input value={form.title} onChange={handleChange("title")} required />
          </label>
          <label>
            Autor
            <input value={form.author} onChange={handleChange("author")} required />
          </label>
          <label>
            Categoria
            <select value={form.category_id} onChange={handleChange("category_id")} required>
              <option value="">Selecione</option>
              {categoryOptions.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </label>
          <label>
            Status
            <select value={form.status} onChange={handleChange("status")}>
              <option value="available">Disponível</option>
              <option value="borrowed">Emprestado</option>
            </select>
          </label>
          <label className="span-2">
            Observações
            <textarea value={form.notes} onChange={handleChange("notes")} />
          </label>
        </div>
        <div className="form-actions">
          <button type="submit" disabled={loading}>
            {editingId ? "Salvar alterações" : "Cadastrar livro"}
          </button>
          {editingId && (
            <button type="button" className="secondary" onClick={resetForm}>
              Cancelar
            </button>
          )}
        </div>
      </form>

      <div className="filters">
        <input
          placeholder="Buscar por título ou autor"
          value={filters.query}
          onChange={handleFilterChange("query")}
        />
        <select value={filters.category_id} onChange={handleFilterChange("category_id")}>
          <option value="">Todas as categorias</option>
          {categoryOptions.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name}
            </option>
          ))}
        </select>
        <select value={filters.status} onChange={handleFilterChange("status")}>
          <option value="">Todos os status</option>
          <option value="available">Disponível</option>
          <option value="borrowed">Emprestado</option>
        </select>
      </div>

      <table className="data-table">
        <thead>
          <tr>
            <th>Título</th>
            <th>Autor</th>
            <th>Categoria</th>
            <th>Status</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {items.map((book) => (
            <tr key={book.id}>
              <td>{book.title}</td>
              <td>{book.author}</td>
              <td>{book.category?.name}</td>
              <td>
                <StatusBadge status={book.status} />
              </td>
              <td className="actions">
                <button type="button" onClick={() => handleEdit(book)}>
                  Editar
                </button>
                <button type="button" className="danger" onClick={() => handleDelete(book)}>
                  Excluir
                </button>
              </td>
            </tr>
          ))}
          {items.length === 0 && (
            <tr>
              <td colSpan={5} className="empty">
                Nenhum livro encontrado.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
