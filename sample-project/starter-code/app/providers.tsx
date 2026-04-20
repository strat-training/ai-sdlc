"use client"

import type React from "react"
import { SessionProvider } from "next-auth/react"
import { TRPCReactProvider } from "@/trpc/react"
import { Toaster } from "sonner"

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <SessionProvider>
      <TRPCReactProvider>
        {children}
        <Toaster richColors position="top-right" />
      </TRPCReactProvider>
    </SessionProvider>
  )
}
