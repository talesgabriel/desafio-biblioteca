import { Navigate, Route, Routes } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./components/ProtectedRoute";
import Layout from "./components/Layout";
import Login from "./pages/Login";
import ForgotPassword from "./pages/ForgotPassword";
import ResetPassword from "./pages/ResetPassword";
import ChangePassword from "./pages/ChangePassword";
import Dashboard from "./pages/Dashboard";
import Categories from "./pages/Categories";
import Books from "./pages/Books";
import LibraryUsers from "./pages/LibraryUsers";
import Loans from "./pages/Loans";
import Librarians from "./pages/Librarians";

export default function App() {
  return (
    <AuthProvider>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/esqueci-senha" element={<ForgotPassword />} />
        <Route path="/reset-password" element={<ResetPassword />} />

        <Route element={<ProtectedRoute />}>
          <Route path="/trocar-senha" element={<ChangePassword />} />

          <Route element={<Layout />}>
            <Route path="/" element={<Dashboard />} />
            <Route path="/categorias" element={<Categories />} />
            <Route path="/livros" element={<Books />} />
            <Route path="/usuarios" element={<LibraryUsers />} />
            <Route path="/emprestimos" element={<Loans />} />
            <Route path="/bibliotecarios" element={<Librarians />} />
          </Route>
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </AuthProvider>
  );
}
