import { Navigate, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "../hooks/useAuth";

export default function ProtectedRoute() {
  const { librarian, loading } = useAuth();
  const location = useLocation();

  if (loading) return <div className="page-loading">Carregando...</div>;
  if (!librarian) return <Navigate to="/login" replace />;
  if (librarian.must_change_password && location.pathname !== "/trocar-senha") {
    return <Navigate to="/trocar-senha" replace />;
  }

  return <Outlet />;
}
