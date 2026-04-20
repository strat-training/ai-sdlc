import { createCallerFactory, createTRPCRouter } from "@/server/trpc"
import { exampleRouter } from "@/server/api/routers/example"
import { itemRouter } from "@/server/api/routers/item"

/**
 * Primary router for the server.
 * Add sub-routers here.
 */
export const appRouter = createTRPCRouter({
  example: exampleRouter,
  item: itemRouter,
});

export type AppRouter = typeof appRouter;

export const createCaller = createCallerFactory(appRouter);
