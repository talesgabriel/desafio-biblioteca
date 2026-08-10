import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { auth } from "../api/resources";
import { useAuth } from "../hooks/useAuth";
import Alert from "../components/Alert";

export default function ChangePassword() {
  const { librarian, refresh } = useAuth();
  const navigate = useNavigate();
  const [currentPassword, setCurrentPassword] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setLoading(true);
    try {
      await auth.changePassword(currentPassword, password);
      await refresh();
      navigate("/", { replace: true });
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <form className="auth-card" onSubmit={handleSubmit}>
        <h1>{librarian?.must_change_password ? "Defina uma nova senha" : "Alterar senha"}</h1>
        {librarian?.must_change_password && (
          <p className="subtitle">
            Este é seu primeiro acesso. Por segurança, defina uma nova senha antes de continuar.
          </p>
        )}
        <Alert>{error}</Alert>
        <label>
          Senha atual
          <input
            type="password"
            value={currentPassword}
            onChange={(e) => setCurrentPassword(e.target.value)}
            required
          />
        </label>
        <label>
          Nova senha
          <input
            type="password"
            minLength={8}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </label>
        <button type="submit" disabled={loading}>
          {loading ? "Salvando..." : "Salvar"}
        </button>
      </form>
    </div>
  );
}
