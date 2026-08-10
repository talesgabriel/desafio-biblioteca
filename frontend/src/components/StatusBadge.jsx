export default function StatusBadge({ status }) {
  const label = status === "available" ? "Disponível" : "Emprestado";
  return <span className={`badge badge-${status}`}>{label}</span>;
}
