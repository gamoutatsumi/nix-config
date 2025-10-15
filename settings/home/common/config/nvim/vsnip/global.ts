// deno-lint-ignore-file no-import-prefix
import { TSSnippet } from "https://deno.land/x/denippet_vim@v0.6.0/loader.ts";

export const snippets: Record<string, TSSnippet> = {
  uuid: {
    prefix: "uuid",
    body: () => crypto.randomUUID(),
  },
  date: {
    prefix: "date",
    body: () => new Date().toUTCString(),
  },
};
