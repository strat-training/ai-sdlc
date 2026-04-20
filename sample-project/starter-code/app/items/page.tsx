"use client"

import { useEffect, useState, type FormEvent } from "react"
import Link from "next/link"
import { api } from "@/trpc/react"
import { toast } from "sonner"
import { Button } from "@/components/ui/button"
import { ArrowLeft } from "lucide-react"

type Status = "active" | "inactive" | "archived"

type Item = {
  id: string
  name: string
  description: string | null
  status: string
  createdAt: Date | string
}

const STATUS_COLOR: Record<Status, string> = {
  active:   "text-emerald-500",
  inactive: "text-amber-500",
  archived: "text-muted-foreground",
}

export default function ItemsPage() {
  const [search, setSearch] = useState("")
  const [debouncedSearch, setDebouncedSearch] = useState("")
  const [page, setPage] = useState(1)
  const [name, setName] = useState("")
  const [description, setDescription] = useState("")

  useEffect(() => {
    const t = setTimeout(() => { setDebouncedSearch(search); setPage(1) }, 300)
    return () => clearTimeout(t)
  }, [search])

  const utils = api.useUtils()

  const { data, isLoading } = api.item.list.useQuery({
    page,
    limit: 10,
    search: debouncedSearch || undefined,
  })

  const createMutation = api.item.create.useMutation({
    onSuccess: () => {
      setName("")
      setDescription("")
      void utils.item.list.invalidate()
      toast.success("Item created")
    },
    onError: (err) => toast.error(err.message),
  })

  const updateStatusMutation = api.item.updateStatus.useMutation({
    onSuccess: () => void utils.item.list.invalidate(),
    onError: (err) => toast.error(err.message),
  })

  const deleteMutation = api.item.delete.useMutation({
    onSuccess: () => {
      void utils.item.list.invalidate()
      toast.success("Item deleted")
    },
    onError: (err) => toast.error(err.message),
  })

  const handleCreate = (e: FormEvent) => {
    e.preventDefault()
    if (!name.trim()) return
    createMutation.mutate({ name: name.trim(), description: description.trim() || undefined })
  }

  const handleToggle = (id: string, current: Status) => {
    const next = current === "active" ? "inactive" : "active"
    updateStatusMutation.mutate({ id, status: next })
  }

  return (
    <div className="mx-auto max-w-4xl px-6 py-8">

      {/* Header */}
      <header className="mb-8">
        <Link
          href="/"
          className="mb-4 inline-flex items-center gap-1.5 text-xs text-muted-foreground transition-colors hover:text-foreground"
        >
          <ArrowLeft size={12} strokeWidth={1.5} />
          Home
        </Link>
        <h1 className="text-2xl font-bold tracking-tight">Items</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Create, update status, or delete entries.
        </p>
      </header>

      {/* Create form */}
      <form onSubmit={handleCreate} className="mb-6 flex flex-wrap gap-2">
        <input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Item name…"
          className="h-10 min-w-44 flex-1 rounded-md border border-border bg-card px-3 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <input
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          placeholder="Description (optional)…"
          className="h-10 min-w-52 flex-[2] rounded-md border border-border bg-card px-3 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <Button type="submit" disabled={createMutation.isPending || !name.trim()}>
          {createMutation.isPending ? "Adding…" : "Add Item"}
        </Button>
      </form>

      {/* Search */}
      <div className="mb-4">
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search items…"
          className="h-9 w-full rounded-md border border-border bg-card px-3 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
      </div>

      {/* Table */}
      <div className="overflow-hidden rounded-lg border border-border bg-card">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border">
              {["Name", "Description", "Status", "Created", ""].map((h) => (
                <th
                  key={h}
                  className="px-4 py-2.5 text-left text-xs font-semibold uppercase tracking-wider text-muted-foreground last:text-right"
                >
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {isLoading ? (
              <tr>
                <td colSpan={5} className="py-10 text-center text-sm text-muted-foreground">
                  Loading…
                </td>
              </tr>
            ) : !data?.items.length ? (
              <tr>
                <td colSpan={5} className="py-10 text-center text-sm text-muted-foreground">
                  {debouncedSearch ? "No items match your search." : "No items yet. Create one above."}
                </td>
              </tr>
            ) : (
              data.items.map((item: Item) => (
                <tr key={item.id} className="border-b border-border last:border-0 transition-colors hover:bg-muted/40">
                  <td className="px-4 py-3 font-medium">{item.name}</td>
                  <td className="px-4 py-3 text-muted-foreground">{item.description ?? "—"}</td>
                  <td className="px-4 py-3">
                    <span className={`inline-flex items-center rounded-full border border-border px-2 py-0.5 text-xs font-medium ${STATUS_COLOR[item.status as Status] ?? STATUS_COLOR.archived}`}>
                      {item.status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-xs text-muted-foreground">
                    {new Intl.DateTimeFormat("en-US", { dateStyle: "medium" }).format(new Date(item.createdAt))}
                  </td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => handleToggle(item.id, item.status as Status)}
                      className="ml-1 rounded border border-border px-2.5 py-1 text-xs font-medium text-muted-foreground transition-colors hover:border-foreground/40 hover:text-foreground"
                    >
                      {item.status === "active" ? "Deactivate" : "Activate"}
                    </button>
                    <button
                      onClick={() => deleteMutation.mutate({ id: item.id })}
                      className="ml-1 rounded border border-destructive/40 px-2.5 py-1 text-xs font-medium text-destructive transition-colors hover:border-destructive hover:bg-destructive/10"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>

        {/* Pagination */}
        {data && data.totalPages > 1 && (
          <div className="flex items-center justify-between border-t border-border px-4 py-2.5 text-xs text-muted-foreground">
            <span>{data.total} items</span>
            <div className="flex gap-1">
              {Array.from({ length: data.totalPages }, (_, i) => (
                <button
                  key={i}
                  onClick={() => setPage(i + 1)}
                  className={`h-7 w-7 rounded text-xs font-medium transition-colors ${
                    data.page === i + 1
                      ? "bg-primary text-primary-foreground"
                      : "border border-border text-muted-foreground hover:bg-muted"
                  }`}
                >
                  {i + 1}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>

    </div>
  )
}
