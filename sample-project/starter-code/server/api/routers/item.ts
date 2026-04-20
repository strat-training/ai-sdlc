import { z } from "zod"
import { createTRPCRouter, publicProcedure } from "@/server/trpc"

export const itemRouter = createTRPCRouter({
  list: publicProcedure
    .input(
      z.object({
        page: z.number().min(1).default(1),
        limit: z.number().min(1).max(100).default(10),
        search: z.string().optional(),
      }),
    )
    .query(async ({ ctx, input }) => {
      const { page, limit, search } = input
      const skip = (page - 1) * limit
      const where = search
        ? {
            OR: [
              { name: { contains: search, mode: "insensitive" as const } },
              { description: { contains: search, mode: "insensitive" as const } },
            ],
          }
        : {}
      const [items, total] = await Promise.all([
        ctx.db.item.findMany({
          where,
          skip,
          take: limit,
          orderBy: { createdAt: "desc" },
        }),
        ctx.db.item.count({ where }),
      ])
      return { items, total, page, totalPages: Math.ceil(total / limit) }
    }),

  create: publicProcedure
    .input(
      z.object({
        name: z.string().min(1, "Name is required"),
        description: z.string().optional(),
      }),
    )
    .mutation(async ({ ctx, input }) => {
      return ctx.db.item.create({ data: input })
    }),

  updateStatus: publicProcedure
    .input(
      z.object({
        id: z.string(),
        status: z.enum(["active", "inactive", "archived"]),
      }),
    )
    .mutation(async ({ ctx, input }) => {
      return ctx.db.item.update({
        where: { id: input.id },
        data: { status: input.status },
      })
    }),

  delete: publicProcedure
    .input(z.object({ id: z.string() }))
    .mutation(async ({ ctx, input }) => {
      return ctx.db.item.delete({ where: { id: input.id } })
    }),
})
