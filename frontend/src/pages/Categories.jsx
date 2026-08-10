import { useEffect, useState } from "react";
import { categories } from "../api/resources";
import Alert from "../components/Alert";

export default function Categories() {
  const [items, setItems] = useState([]);
  const [name, setName] = useState("");
  const [editingId, setEditingId] = useState(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const load = async () => setItems(await categories.list());

  useEffect(() => {
    load();
  }, []);

  const resetForm = () => {
    setName("");
    setEditingId(null);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setLoading(true);
    try {
      if (editingId) {
        await categories.update(editingId, { name });
      } else {
        await categories.create({ name });
      }
      resetForm();
      await load();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (category) => {
    setEditingId(category.id);
    setName(category.name);
  };

  const handleDelete = async (category) => {
    if (!window.confirm(`Excluir a categoria "${category.name}"?`)) return;
    setError("");
    try {
      await categories.remove(category.id);
      await load();
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div>
      <h1>Categorias</h1>
      <Alert>{error}</Alert>
      <form className="inline-form" onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Nome da categoria"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <button type="submit" disabled={loading}>
          {editingId ? "Salvar" : "Adicionar"}
        </button>
        {editingId && (
          <button type="button" className="secondary" onClick={resetForm}>
            Cancelar
          </button>
        )}
      </form>

      <table className="data-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {items.map((category) => (
            <tr key={category.id}>
              <td>{category.name}</td>
              <td className="actions">
                <button type="button" onClick={() => handleEdit(category)}>
                  Editar
                </button>
                <button type="button" className="danger" onClick={() => handleDelete(category)}>
                  Excluir
                </button>
              </td>
            </tr>
          ))}
          {items.length === 0 && (
            <tr>
              <td colSpan={2} className="empty">
                Nenhuma categoria cadastrada.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
