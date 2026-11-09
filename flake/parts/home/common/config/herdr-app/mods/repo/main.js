// Repository dialog: { action: "new" | "open" }; optional { space, folder,
// machine, tab, argv }. "new" clones with `ghq get --clean-bare`; "open" lists
// the repos under `ghq root`.

import { div, View } from "gpui-kit";
import { h_flex, Input, InputState, Scrollbar, v_flex } from "gpui-base";
import {
  closeOverlay,
  exec,
  machines,
  openOverlay,
  panes,
  props,
  run,
  spaces,
  theme,
} from "herdr";

const norm = (path) => path.replace(/\\/g, "/");

// Where a space is now: its first terminal's live folder, else where it was made.
function place(s, all = panes()) {
  const tabs = new Set((s.tabs ?? []).map((c) => c.id));
  return all.find((p) => tabs.has(p.tab) && p.cwd)?.cwd || s.folder || null;
}

// `org/repo` out of whatever ghq accepts (`org/repo`, an https or ssh URL),
// so the clone can be found again: ghq doesn't print where it put it.
function specOf(input) {
  const s = input.trim().replace(/\/+$/, "").replace(/\.git$/, "");
  const m = s.match(/([^/:\\]+)\/([^/:\\]+)$/);
  return m ? `${m[1]}/${m[2]}` : null;
}

async function ghq(args, on) {
  const r = await exec("ghq", args, { on });
  return {
    ok: r.code === 0,
    out: (r.stdout ?? "").trim(),
    err: (r.stderr ?? r.stdout ?? "").trim(),
  };
}

// The space showing a repo: its first terminal is in the repo folder.
function spaceOf(path, on, spaceList, paneList) {
  return spaceList.find((s) => {
    if ((s.machine ?? null) !== (on ?? null)) return false;
    const at = place(s, paneList);
    if (!at) return false;
    const p = norm(at);
    return p === path || p.startsWith(path + "/");
  });
}

// Whether a repo has checkouts beyond its own. A bare clone (what "new" makes)
// has no main checkout, so any listed worktree counts; otherwise the first
// entry is the main one and doesn't.
async function hasWorktrees(path, on) {
  const r = await exec("git", ["worktree", "list", "--porcelain"], {
    cwd: path,
    on,
  });
  if (r.code !== 0) return false;
  const blocks = (r.stdout ?? "").trim().split(/\n\n+/).filter(Boolean);
  const bare = blocks.some((b) => b.split("\n").includes("bare"));
  const checkouts = blocks.filter((b) => !b.split("\n").includes("bare"));
  return checkouts.length > (bare ? 0 : 1);
}

export default class Repo extends View {
  init(_props, cx) {
    const p = props() ?? {};
    // Default to the machine being looked at, as new spaces do.
    this.on = p.machine ??
      (spaces().find((s) => s.id === p.space) ??
        spaces().find((s) => s.active))?.machine ??
      null;
    this.opening = p.action === "open";
    this.text = "";
    this.at = 0;
    this.list = undefined; // open: the repos, once read
    this.root = "";
    this.busy = false;
    this.error = "";
    this.input = InputState.new({
      value: "",
      placeholder: this.opening ? "filter repositories" : "owner/repo or URL",
    });
    this.input.on("change", (_e, cx) => {
      this.text = this.input.value();
      this.error = "";
      this.at = 0;
      cx.notify();
    });
    this.input.on("submit", (_e, cx) => this.go(cx));
    this.inputFocused = true;
    this.input.on("focus", (_e, cx) => {
      this.inputFocused = true;
      cx.notify();
    });
    this.input.on("blur", (_e, cx) => {
      this.inputFocused = false;
      cx.notify();
    });
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    this.handle = cx.focus_handle();
    this.load(cx);
  }

  // Re-read ghq's root and repos on the chosen machine. A slow answer from a
  // machine the user has since left must not overwrite the current one.
  load(cx) {
    const token = (this.token = (this.token ?? 0) + 1);
    this.ready = false;
    this.list = undefined;
    this.root = "";
    this.error = "";
    this.at = 0;
    cx.notify();
    cx.spawn(async (cx) => {
      let list;
      let root = "";
      let error = "";
      try {
        const r = await ghq(["root"], this.on);
        if (!r.ok || !r.out) throw new Error(r.err || "ghq root failed.");
        root = norm(r.out.split("\n")[0]);
        if (this.opening) {
          const all = await ghq(["list", "-p"], this.on);
          if (!all.ok) throw new Error(all.err || "ghq list failed.");
          list = all.out.split("\n").filter(Boolean).map(norm).map((path) => ({
            path,
            // Without the host: `org/repo`.
            name: path.split("/").slice(-2).join("/"),
            rel: path.startsWith(root + "/")
              ? path.slice(root.length + 1)
              : path,
          }));
        }
      } catch (e) {
        list = this.opening ? [] : undefined;
        error = String(e);
      }
      if (token !== this.token) return;
      this.root = root;
      this.list = list;
      this.error = error;
      this.ready = true;
      cx.notify();
    });
  }

  pick(name, cx) {
    if (this.busy || name === this.on) return;
    this.on = name;
    this.load(cx);
  }

  close() {
    closeOverlay(props().overlay);
  }

  go(cx) {
    if (this.busy || !this.ready) return;
    if (this.opening) return this.open(this.shown()[this.at]);
    cx.spawn((cx) => this.work(cx));
  }

  async work(cx) {
    this.busy = true;
    this.error = "";
    cx.notify();
    try {
      this.error = await this.clone();
    } catch (error) {
      this.error = String(error);
    }
    this.busy = false;
    if (!this.error) this.close();
    cx.notify();
  }

  async clone() {
    const input = this.text.trim();
    if (!input) return "Type owner/repo or a URL.";
    const spec = specOf(input);
    if (!spec) return "Couldn't read an owner/repo from that.";
    const r = await ghq(["get", "--clean-bare", input], this.on);
    if (!r.ok) return r.err || "ghq get failed.";
    const found = await ghq(["list", "-p", "-e", spec], this.on);
    const path = found.out.split("\n").filter(Boolean).map(norm)[0];
    if (!found.ok || !path) return `Cloned, but couldn't find ${spec} in ghq.`;
    const p = props();
    // Leave spaces unnamed so they follow the folder and nest under the repo.
    run("space.new", {
      folder: path,
      machine: this.on,
      tab: p.tab,
      argv: p.argv,
    });
    return "";
  }

  shown() {
    const f = this.text.trim().toLowerCase();
    return (this.list ?? []).filter((c) =>
      !f || c.rel.toLowerCase().includes(f)
    );
  }

  open(c) {
    if (!c || this.busy) return;
    this.busy = true;
    // Decide before closing: the dialog must stay alive while git runs.
    hasWorktrees(c.path, this.on).catch(() => false).then((many) => {
      this.busy = false;
      this.close();
      if (many) {
        // Which checkout to open is the user's call, so hand over to the picker.
        openOverlay({
          mod: "worktree",
          kind: "dialog",
          width: 560,
          height: 480,
          props: { folder: c.path, machine: this.on, action: "open" },
        });
        return;
      }
      const s = spaceOf(c.path, this.on, spaces(), panes());
      if (s) run("space.select", { id: s.id });
      else run("space.new", { folder: c.path, machine: this.on });
    });
  }

  key(e, cx) {
    if (e.key === "escape") return this.close();
    if (!this.opening) return;
    const n = this.shown().length;
    if ((e.key === "down" || e.key === "up") && n) {
      this.at = (this.at + (e.key === "down" ? 1 : n - 1)) % n;
    } else return;
    cx.stop_propagation();
    cx.notify();
  }

  // Only worth showing once there is a second machine to choose.
  machineNames() {
    return machines().filter((m) => m.layout !== "unavailable").map((m) =>
      m.name
    );
  }

  machineBar(t) {
    const names = this.machineNames();
    return h_flex().gap(6).flex_wrap().children(names.map((name, i) => {
      const on = name === this.on;
      return div()
        .id(`repo-machine-${i}`)
        .px(8).py(3).rounded(6).text_size(12).cursor_pointer()
        .text_color(on ? t.foreground : t.muted)
        .when(on, (el) => el.bg(t.selected))
        .when(!on, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click((_e, cx) => this.pick(name, cx))
        .child(name ?? "This computer");
    }));
  }

  field(t) {
    return Input.new(this.input).h(32).px(10).items_center().rounded(6)
      .border(1).border_color(this.inputFocused ? t.accent : t.input)
      .bg(t.background).text_color(t.foreground);
  }

  renderOpen(t) {
    const rows = this.shown();
    const all = this.list ?? [];
    const spaceList = spaces();
    const paneList = panes();
    const row = (c, i) => {
      const on = i === this.at;
      const there = spaceOf(c.path, this.on, spaceList, paneList);
      return v_flex()
        .id(`repo-${i}`)
        .flex_none()
        .h(44)
        .px(10)
        .justify_center()
        .rounded(7)
        .cursor_pointer()
        .when(on, (el) => el.bg(t.selected))
        .when(!on, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click(() => this.open(c))
        .child(
          h_flex().gap(8).items_center()
            .child(
              div().flex_1().min_w(0).truncate().text_color(t.foreground).child(
                c.name,
              ),
            )
            .when(
              Boolean(there),
              (el) =>
                el.child(
                  div().flex_none().text_size(11).text_color(t.accent).child(
                    "open",
                  ),
                ),
            ),
        )
        .child(
          div().truncate().text_size(11.5).text_color(t.dim).child(c.rel),
        );
    };
    const count = rows.length === all.length
      ? `${all.length} repositories`
      : `${rows.length}/${all.length} repositories`;
    return v_flex()
      .id("repo")
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .size_full()
      .p(16)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .child(
        h_flex().child(
          div().flex_1().font_semibold().text_color(t.foreground).child(
            "Open repository",
          ),
        ).child(
          div().text_size(11).text_color(t.dim).child(this.list ? count : ""),
        ),
      )
      .when(
        !this.ready,
        (el) => el.child(div().text_color(t.muted).child("…")),
      )
      .when(
        Boolean(this.error),
        (el) => el.child(div().text_color(t.blocked).child(this.error)),
      )
      .when(
        this.machineNames().length > 1,
        (el) => el.child(this.machineBar(t)),
      )
      .when(Boolean(this.ready && this.list), (el) =>
        el
          .child(this.field(t))
          .child(
            div().relative().flex_1().min_h(0)
              .child(
                v_flex()
                  .id("repo-list")
                  .size_full()
                  .overflow_y_scroll()
                  .children(rows.map(row))
                  .when(rows.length === 0, (el) =>
                    el.child(
                      div().p(10).text_color(t.dim).child(
                        "No matching repositories.",
                      ),
                    )),
              )
              .child(Scrollbar.vertical("repo-list").absolute().inset_0()),
          ))
      .child(
        h_flex().justify_end().text_size(11).text_color(t.dim).child(
          "↑↓ choose · ↵ open · esc close",
        ),
      );
  }

  render(_cx) {
    const t = theme();
    if (this.opening) return this.renderOpen(t);
    return v_flex()
      .id("repo")
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .size_full()
      .p(16)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .child(
        div().font_semibold().text_color(t.foreground).child(
          "Clone repository",
        ),
      )
      .child(
        div().text_color(t.muted).child(
          this.root
            ? `A bare clone under ${this.root}, opened as a new space.`
            : "…",
        ),
      )
      .when(
        this.machineNames().length > 1,
        (el) => el.child(this.machineBar(t)),
      )
      .child(this.field(t))
      .when(
        Boolean(this.error),
        (el) => el.child(div().text_color(t.blocked).child(this.error)),
      )
      .child(div().flex_1())
      .child(
        h_flex().justify_end().text_size(11).text_color(t.dim).child(
          this.busy ? "cloning…" : "↵ clone · esc cancel",
        ),
      );
  }
}
