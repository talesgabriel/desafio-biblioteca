import { useCallback, useEffect, useState } from "react";
import { auth } from "../api/resources";
import { AuthContext } from "./auth-context";

export function AuthProvider({ children }) {
  const [librarian, setLibrarian] = useState(null);
  const [loading, setLoading] = useState(true);

  const loadSession = useCallback(async () => {
    const token = localStorage.getItem("authToken");
    if (!token) {
      setLoading(false);
      return;
    }
    try {
      const me = await auth.me();
      setLibrarian(me);
    } catch {
      localStorage.removeItem("authToken");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadSession();
  }, [loadSession]);

  const login = async (email, password) => {
    const data = await auth.login(email, password);
    localStorage.setItem("authToken", data.auth_token);
    setLibrarian(data);
    return data;
  };

  const logout = async () => {
    try {
      await auth.logout();
    } catch {
      // token may already be invalid; proceed with local logout regardless
    }
    localStorage.removeItem("authToken");
    setLibrarian(null);
  };

  const refresh = async () => {
    const me = await auth.me();
    setLibrarian(me);
  };

  return (
    <AuthContext.Provider value={{ librarian, loading, login, logout, refresh }}>
      {children}
    </AuthContext.Provider>
  );
}
