import { api } from "./client";

export const auth = {
  login: (email, password) => api.post("/login", { email, password }),
  logout: () => api.delete("/logout"),
  me: () => api.get("/me"),
  forgotPassword: (email) => api.post("/password/forgot", { email }),
  resetPassword: (token, password) => api.post("/password/reset", { token, password }),
  changePassword: (current_password, password) =>
    api.patch("/password/change", { current_password, password }),
};

export const librarians = {
  list: () => api.get("/librarians"),
  create: (data) => api.post("/librarians", { librarian: data }),
};

export const categories = {
  list: () => api.get("/categories"),
  create: (data) => api.post("/categories", { category: data }),
  update: (id, data) => api.patch(`/categories/${id}`, { category: data }),
  remove: (id) => api.delete(`/categories/${id}`),
};

export const books = {
  list: (params = {}) => {
    const query = new URLSearchParams(
      Object.fromEntries(Object.entries(params).filter(([, v]) => v))
    ).toString();
    return api.get(`/books${query ? `?${query}` : ""}`);
  },
  create: (data) => api.post("/books", { book: data }),
  update: (id, data) => api.patch(`/books/${id}`, { book: data }),
  remove: (id) => api.delete(`/books/${id}`),
};

export const libraryUsers = {
  list: (params = {}) => {
    const query = new URLSearchParams(
      Object.fromEntries(Object.entries(params).filter(([, v]) => v))
    ).toString();
    return api.get(`/library_users${query ? `?${query}` : ""}`);
  },
  create: (data) => api.post("/library_users", { library_user: data }),
  update: (id, data) => api.patch(`/library_users/${id}`, { library_user: data }),
  remove: (id) => api.delete(`/library_users/${id}`),
};

export const loans = {
  list: (params = {}) => {
    const query = new URLSearchParams(
      Object.fromEntries(Object.entries(params).filter(([, v]) => v))
    ).toString();
    return api.get(`/loans${query ? `?${query}` : ""}`);
  },
  overdue: () => api.get("/loans/overdue"),
  create: (data) => api.post("/loans", data),
  returnLoan: (id) => api.patch(`/loans/${id}/return`),
};

export const dashboard = {
  summary: () => api.get("/dashboard"),
};
