// deno-lint-ignore-file no-import-prefix
import { defineConfig } from "jsr:@yuki-yano/zeno@0.2.0";

type RequireOne<T, K extends keyof T = keyof T> = K extends keyof T
  ? PartialRequire<T, K>
  : never;
type PartialRequire<O, K extends keyof O> =
  & {
    [P in K]-?: O[P];
  }
  & O;

type Context = RequireOne<
  { lbuffer?: string; rbuffer?: string; buffer?: string }
>;

const CONTEXTS: Record<string, Context> = {
  commit: { lbuffer: "git\\scommit\\s+" },
  git: { lbuffer: "git\\s+" },
  diff: { lbuffer: "git\\sdiff\\s+" },
  checkout: { lbuffer: "git\\scheckout\\s+" },
  workflow: { lbuffer: "gh\\sworkflow\\s.*" },
  any: { lbuffer: ".+\\s+" },
};

export default defineConfig(() => {
  return {
    snippets: [
      {
        name: "docker compose",
        keyword: "dc",
        snippet: "docker compose",
      },
      {
        name: "pipe to vim",
        keyword: "V",
        snippet: "| vim -",
        context: CONTEXTS.any,
      },
      {
        name: "git status short branch",
        keyword: "gs",
        snippet: "git status --short --branch",
      },
      {
        name: "git clean fdx",
        keyword: "call",
        snippet: "clean -fdx",
        context: CONTEXTS.git,
      },
      {
        name: "git add",
        keyword: "ga",
        snippet: "git add {{file}}",
      },
      {
        name: "git add all",
        keyword: "gaa",
        snippet: "git add --all",
      },
      {
        name: "git commit",
        keyword: "gci",
        snippet: "git commit",
      },
      {
        name: "git commit message",
        keyword: "gcim",
        snippet: "git commit -m '{{commit_message}}'",
      },
      {
        name: "git commit fixup",
        keyword: "f",
        snippet: "--fixup {{commit_id}}",
        context: CONTEXTS.commit,
      },
      {
        name: "git commit amend",
        keyword: "a",
        snippet: "--amend",
        context: CONTEXTS.commit,
      },
      {
        name: "git commit amend noedit",
        keyword: "an",
        snippet: "--amend --no-edit",
        context: CONTEXTS.commit,
      },
      {
        name: "git empty commit",
        keyword: "init",
        snippet: "--allow-empty -m 'Initial Commit'",
        context: CONTEXTS.commit,
      },
      {
        name: "git diff",
        keyword: "gd",
        snippet: "git diff {{branch}}",
      },
      {
        name: "git diff file",
        keyword: "f",
        snippet: "git diff -- {{file}}",
        context: CONTEXTS.diff,
      },
      {
        name: "git diff branch file",
        keyword: "bf",
        snippet: "{{branch}} -- {{file}}",
        context: CONTEXTS.diff,
      },
      {
        name: "git diff 2 branch",
        keyword: "bb",
        snippet: "{{branch1}} {{brahcn2}}",
        context: CONTEXTS.diff,
      },
      {
        name: "git diff 2 branch file",
        keyword: "bbf",
        snippet: "{{branch1}} {{brahcn2}} -- {{file}}",
        context: CONTEXTS.diff,
      },
      {
        name: "git diff cached",
        keyword: "c",
        snippet: "--cached",
        context: CONTEXTS.diff,
      },
      {
        name: "git diff cached file",
        keyword: "cf",
        snippet: "--cached -- {{file}}",
        context: CONTEXTS.diff,
      },
      {
        name: "git checkout",
        keyword: "gco",
        snippet: "git checkout {{branch}}",
      },
      {
        name: "git checkout file",
        keyword: "f",
        snippet: "-- {{file}}",
        context: CONTEXTS.checkout,
      },
      {
        name: "git checkout branch file",
        keyword: "bf",
        snippet: "{{branch}} -- {{file}}",
        context: CONTEXTS.checkout,
      },
      {
        name: "git checkout track",
        keyword: "t",
        snippet: "--track {{origin_branch}}",
        context: CONTEXTS.checkout,
      },
      {
        name: "git rebase squash",
        keyword: "squash",
        snippet: "rebase --interactive --autosquash {{branch}}",
        context: CONTEXTS.git,
      },
      {
        name: "git main branch",
        keyword: "main_branch",
        snippet:
          'basename "$(git symbolic-ref --short refs/remotes/origin/HEAD)"',
      },
      {
        name: "git new branch with date suffix",
        keyword: "gnb",
        snippet: 'git switch -c "{{branch}}_$(date +%Y%m%d)"',
      },
      {
        name: "tms",
        keyword: "t",
        snippet: "tms",
      },
      {
        name: "tmux swap pane",
        keyword: "ts",
        snippet: "tmux swap-pane -t",
      },
      {
        name: "null",
        keyword: "null",
        snippet: "> /dev/null 2>&1",
        context: CONTEXTS.any,
      },
      {
        name: "stdout to null",
        keyword: "null1",
        snippet: "> /dev/null",
        context: CONTEXTS.any,
      },
      {
        name: "stderr to null",
        keyword: "null2",
        snippet: "2> /dev/null",
        context: CONTEXTS.any,
      },
      {
        name: "pipe grep",
        keyword: "G",
        snippet: "| rg '{{pattern}}'",
        context: CONTEXTS.any,
      },
      {
        name: "pipe head",
        keyword: "H",
        snippet: "| head -n ",
        context: CONTEXTS.any,
      },
      {
        name: "copy stdout",
        keyword: "C",
        snippet: "| pbcopy",
        context: CONTEXTS.any,
      },
      {
        name: "pipe less",
        keyword: "L",
        snippet: "| less",
        context: CONTEXTS.any,
      },
      {
        name: "pipe jq",
        keyword: "J",
        snippet: "| jq .{{query}}",
        context: CONTEXTS.any,
      },
      {
        name: "pipe gron",
        keyword: "JG",
        snippet: " | gron | grep",
        context: CONTEXTS.any,
      },
      {
        name: "ungron",
        keyword: "UG",
        snippet: " | gron -u",
        context: CONTEXTS.any,
      },
      {
        name: "branch",
        keyword: "B",
        snippet: "git symbolic-ref --short HEAD",
        context: CONTEXTS.checkout,
        evaluate: true,
      },
      {
        name: "git switch",
        keyword: "gsw",
        snippet: "git switch {{branch}}",
      },
      {
        name: "git switch create",
        keyword: "gswc",
        snippet: "git switch -c {{branch}}",
      },
    ],
    completions: [],
  };
});
