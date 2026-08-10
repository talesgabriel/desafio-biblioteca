import { useState } from "react";
import { Link } from "react-router-dom";
import { auth } from "../api/resources";
import Alert from "../components/Alert";

export default function ForgotPassword() {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setMessage("");
    setLoading(true);
    try {
      const data = await auth.forgotPassword(email);
      setMessage(data.message);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <form className="auth-card" onSubmit={handleSubmit}>
        <h1>Recuperar senha</h1>
        <Alert>{error}</Alert>
        <Alert type="success">{message}</Alert>
        <label>
          E-mail
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        </label>
        <button type="submit" disabled={loading}>
          {loading ? "Enviando..." : "Enviar instruções"}
        </button>
        <Link to="/login" className="link">
          Voltar para o login
        </Link>
      </form>
    </div>
  );
}
