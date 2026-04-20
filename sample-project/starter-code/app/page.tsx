"use client"

import { useState } from "react"
import Link from "next/link"
import {
  Shield, Database, Zap, LayoutTemplate, FlaskConical, Lock,
  ArrowRight, X, Terminal, Copy, Check,
} from "lucide-react"

const FONT = '"Inter", "Helvetica Neue", Arial, sans-serif'

const FEATURES = [
  { icon: Shield,         title: "Authentication",      desc: "NextAuth v4 with GitHub & Google OAuth, JWT sessions, and Prisma adapter" },
  { icon: Database,       title: "PostgreSQL + Prisma",  desc: "Type-safe ORM with migrations and connection pooling via pg adapter" },
  { icon: Zap,            title: "tRPC v11",             desc: "End-to-end type-safe API layer with React Query integration" },
  { icon: LayoutTemplate, title: "Next.js App Router",   desc: "Server components, streaming SSR, and Turbopack dev server" },
  { icon: FlaskConical,   title: "Testing",              desc: "Vitest + MSW for unit and API integration tests out of the box" },
  { icon: Lock,           title: "Security",             desc: "CSRF protection, Zod validation, and input sanitization built in" },
] as const

const STEPS = [
  {
    step: "1",
    title: "Install dependencies",
    code: "pnpm install",
  },
  {
    step: "2",
    title: "Set up environment variables",
    code: "cp .env.example .env.local",
    note: "Fill in DATABASE_URL, AUTH_SECRET, and OAuth credentials in .env.local",
  },
  {
    step: "3",
    title: "Start the database",
    code: "docker compose up -d",
  },
  {
    step: "4",
    title: "Push schema & seed",
    code: "pnpm db:push && pnpm db:seed",
  },
  {
    step: "5",
    title: "Start the dev server",
    code: "pnpm dev",
    note: "App runs at http://localhost:3000",
  },
]

function CodeLine({ code }: { code: string }) {
  const [copied, setCopied] = useState(false)

  const handleCopy = () => {
    void navigator.clipboard.writeText(code)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <div style={{
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      gap: 12,
      background: "#0a0a0a",
      border: "1px solid #2e2e2e",
      borderRadius: 6,
      padding: "10px 14px",
      fontFamily: '"Geist Mono", "Fira Code", monospace',
    }}>
      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
        <Terminal size={12} strokeWidth={1.5} color="#454545" />
        <span style={{ fontSize: "0.8125rem", color: "#ededed", letterSpacing: "0.01em" }}>{code}</span>
      </div>
      <button
        onClick={handleCopy}
        style={{ background: "none", border: "none", cursor: "pointer", padding: 2, color: "#454545", display: "flex" }}
      >
        {copied
          ? <Check size={13} strokeWidth={2} color="#50e3c2" />
          : <Copy size={13} strokeWidth={1.5} />
        }
      </button>
    </div>
  )
}

function GetStartedModal({ onClose }: { onClose: () => void }) {
  return (
    <div
      onClick={onClose}
      style={{
        position: "fixed", inset: 0, zIndex: 50,
        background: "rgba(0,0,0,0.8)",
        display: "flex", alignItems: "center", justifyContent: "center",
        padding: "24px 16px",
        backdropFilter: "blur(4px)",
      }}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{
          background: "#111",
          border: "1px solid #2e2e2e",
          borderRadius: 12,
          width: "100%",
          maxWidth: 560,
          maxHeight: "90vh",
          overflowY: "auto",
          fontFamily: FONT,
        }}
      >
        {/* Modal header */}
        <div style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          padding: "20px 24px",
          borderBottom: "1px solid #2e2e2e",
        }}>
          <div>
            <div style={{ fontSize: "0.9375rem", fontWeight: 600, color: "#ededed", letterSpacing: "-0.015em" }}>
              Get Started
            </div>
            <div style={{ fontSize: "0.75rem", color: "#878787", marginTop: 2 }}>
              Set up your local development environment
            </div>
          </div>
          <button
            onClick={onClose}
            style={{ background: "none", border: "none", cursor: "pointer", color: "#454545", display: "flex", padding: 4 }}
          >
            <X size={18} strokeWidth={1.5} />
          </button>
        </div>

        {/* Steps */}
        <div style={{ padding: "20px 24px", display: "flex", flexDirection: "column", gap: 20 }}>
          {STEPS.map(({ step, title, code, note }) => (
            <div key={step} style={{ display: "flex", gap: 14 }}>
              <div style={{
                width: 22, height: 22, borderRadius: "50%",
                border: "1px solid #2e2e2e", background: "#1a1a1a",
                display: "flex", alignItems: "center", justifyContent: "center",
                flexShrink: 0, marginTop: 1,
              }}>
                <span style={{ fontSize: "0.625rem", fontWeight: 600, color: "#878787" }}>{step}</span>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: "0.8125rem", fontWeight: 500, color: "#ededed", marginBottom: 8, letterSpacing: "-0.01em" }}>
                  {title}
                </div>
                <CodeLine code={code} />
                {note && (
                  <div style={{ fontSize: "0.75rem", color: "#878787", marginTop: 6, letterSpacing: "-0.006em" }}>
                    {note}
                  </div>
                )}
              </div>
            </div>
          ))}

          {/* Dashboard link */}
          <div style={{ paddingTop: 4, borderTop: "1px solid #2e2e2e", marginTop: 4 }}>
            <div style={{ fontSize: "0.75rem", color: "#878787", marginBottom: 12 }}>
              Once running, explore the sample CRUD dashboard:
            </div>
            <Link
              href="/items"
              onClick={onClose}
              style={{
                display: "inline-flex", alignItems: "center", gap: 6,
                height: 36, padding: "0 16px", borderRadius: 6,
                background: "#ededed", color: "#000",
                fontSize: "0.875rem", fontWeight: 600,
                letterSpacing: "-0.01em", textDecoration: "none",
              }}
            >
              Open Sample App <ArrowRight size={14} strokeWidth={2} />
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}

const APP_NAME = "${{ values.appName }}"
const APP_DESCRIPTION = "${{ values.description }}"

export default function LandingPage() {
  const [modalOpen, setModalOpen] = useState(false)

  return (
    <div style={{
      minHeight: "100vh",
      background: "#000",
      backgroundImage: "radial-gradient(circle, #2e2e2e 1px, transparent 1px)",
      backgroundSize: "24px 24px",
      fontFamily: FONT,
      color: "#ededed",
      display: "flex",
      flexDirection: "column",
    }}>
      {/* Nav */}
      <nav style={{
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        padding: "0 32px",
        height: 64,
        borderBottom: "1px solid #2e2e2e",
        flexShrink: 0,
      }}>
        <span style={{ fontSize: "0.9375rem", fontWeight: 600, letterSpacing: "-0.02em", color: "#ededed" }}>
{APP_NAME}
        </span>
        <Link
          href="/items"
          style={{
            display: "inline-flex", alignItems: "center", gap: 6,
            height: 36, padding: "0 14px", borderRadius: 6,
            fontSize: "0.875rem", fontWeight: 500,
            color: "#ededed", textDecoration: "none",
            border: "1px solid #2e2e2e", letterSpacing: "-0.006em",
          }}
        >
          Sample App <ArrowRight size={14} strokeWidth={1.5} aria-hidden="true" />
        </Link>
      </nav>

      {/* Hero */}
      <div style={{
        flex: 1,
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "64px 32px",
        textAlign: "center",
      }}>
        <div style={{ maxWidth: 720, marginBottom: 48 }}>
          {/* Badge */}
          <div style={{
            display: "inline-flex", alignItems: "center", gap: 6,
            padding: "4px 12px", borderRadius: 100,
            border: "1px solid #2e2e2e",
            fontSize: "0.75rem", color: "#878787",
            marginBottom: 24, letterSpacing: "0.02em",
          }}>
            <Zap size={12} strokeWidth={1.5} aria-hidden="true" />
            Next.js Fullstack Boilerplate
          </div>

          {/* Title */}
          <h1 style={{
            fontSize: "clamp(2.5rem, 5vw, 4rem)",
            fontWeight: 700, letterSpacing: "-0.06em",
            lineHeight: 1.05, margin: "0 0 12px", color: "#ededed",
          }}>
  {APP_NAME}
          </h1>

          <p style={{
            fontSize: "clamp(1.5rem, 3vw, 2.25rem)",
            fontWeight: 600, letterSpacing: "-0.04em",
            lineHeight: 1.1, color: "#878787",
            margin: "0 auto 20px",
          }}>
            Full-stack. Type-safe. Production-ready.
          </p>

          {/* Description */}
          <p style={{
            fontSize: "0.9375rem", color: "#878787",
            lineHeight: 1.6, letterSpacing: "-0.01em",
            margin: "0 auto 32px", maxWidth: 560,
          }}>
            {APP_DESCRIPTION}
          </p>

          {/* CTAs */}
          <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10 }}>
            <button
              onClick={() => setModalOpen(true)}
              style={{
                display: "inline-flex", alignItems: "center", gap: 8,
                height: 44, padding: "0 24px", borderRadius: 8,
                border: "none", background: "#ededed", color: "#000",
                fontSize: "0.9375rem", fontWeight: 600,
                letterSpacing: "-0.01em", cursor: "pointer",
                fontFamily: "inherit", transition: "background 0.15s",
              }}
              onMouseEnter={e => { (e.currentTarget as HTMLButtonElement).style.background = "#d4d4d4" }}
              onMouseLeave={e => { (e.currentTarget as HTMLButtonElement).style.background = "#ededed" }}
            >
              Get Started
              <ArrowRight size={16} strokeWidth={2} aria-hidden="true" />
            </button>
            <Link
              href="/items"
              style={{
                display: "inline-flex", alignItems: "center", gap: 8,
                height: 44, padding: "0 24px", borderRadius: 8,
                border: "1px solid #2e2e2e", background: "transparent",
                color: "#ededed", fontSize: "0.9375rem", fontWeight: 500,
                letterSpacing: "-0.01em", textDecoration: "none",
                transition: "border-color 0.15s",
              }}
            >
              View Sample App
            </Link>
          </div>
        </div>

        {/* Features grid */}
        <div style={{
          display: "grid",
          gridTemplateColumns: "repeat(3, minmax(0, 1fr))",
          gap: 12, maxWidth: 900, width: "100%",
        }}>
          {FEATURES.map(({ icon: Icon, title, desc }) => (
            <div
              key={title}
              style={{
                padding: "16px 18px", borderRadius: 8,
                border: "1px solid #2e2e2e", background: "#0a0a0a",
                textAlign: "left",
              }}
            >
              <div style={{
                width: 28, height: 28, borderRadius: 6,
                background: "#1a1a1a", border: "1px solid #2e2e2e",
                display: "flex", alignItems: "center", justifyContent: "center",
                marginBottom: 10,
              }}>
                <Icon size={14} strokeWidth={1.5} color="#878787" aria-hidden="true" />
              </div>
              <div style={{ fontSize: "0.8125rem", fontWeight: 600, color: "#ededed", letterSpacing: "-0.01em", marginBottom: 4 }}>
                {title}
              </div>
              <div style={{ fontSize: "0.75rem", color: "#878787", lineHeight: 1.5 }}>
                {desc}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Footer */}
      <footer style={{
        borderTop: "1px solid #2e2e2e",
        padding: "20px 32px",
        display: "flex", alignItems: "center",
        justifyContent: "space-between",
        flexWrap: "wrap", gap: 12, flexShrink: 0,
      }}>
        <span style={{ fontSize: "0.75rem", color: "#454545" }}>
{APP_NAME} &middot; {new Date().getFullYear()}
        </span>
        <span style={{ fontSize: "0.75rem", color: "#454545" }}>
          Built with Next.js &middot; tRPC &middot; Prisma
        </span>
      </footer>

      {/* Modal */}
      {modalOpen && <GetStartedModal onClose={() => setModalOpen(false)} />}
    </div>
  )
}
