# keys.json is generated in full: it replaces Herdr's defaults entirely, and
# the app's own defaults can't be read from here. Linux has no cmd, and plain
# ctrl+letters belong to the program, so its bindings use ctrl-shift / ctrl-alt.
{ lib, isDarwin }:
let
  pick = darwin: other: if isDarwin then darwin else other;
  m = pick "cmd" "ctrl-shift";
  # cmd-shift-X collides with m-X on Linux, so the shifted variants move to ctrl-alt.
  ms = pick "cmd-shift" "ctrl-alt";
  ma = pick "cmd-alt" "ctrl-alt";
  mas = pick "cmd-alt-shift" "ctrl-alt-shift";
  tabSelect = pick "cmd" "alt";
  directions = [
    "left"
    "right"
    "up"
    "down"
  ];
  digits = map toString (lib.range 1 9);
  forDigits = lib.genAttrs' digits;
  forDirections = lib.genAttrs' directions;
in
{
  global = {
    "ctrl-tab" = "tab.next";
    "ctrl-shift-tab" = "tab.prev";
    "${m}-t" = "tab.new";
    "${m}-w" = "tab.close";
    "${m}-n" = "space.new";
    "${m}-d" = "pane.split:right";
    "${ms}-d" = "pane.split:down";
    "${ms}-w" = "pane.close";
    "${ms}-enter" = "pane.zoom";
    "${ms}-l" = "layout.switch";
    "${m}-b" = "layout.toggle:sidebar";
    "${m}-," = "app.settings";
    "${m}-/" = "app.help";
    "${m}-=" = "app.zoom_in";
    "${m}--" = "app.zoom_out";
    "${m}-0" = "app.zoom_reset";
    "${m}-]" = "agent.next";
    "${m}-[" = "agent.prev";
    "${ma}-]" = "space.next";
    "${ma}-[" = "space.prev";
    "f2" = "tab.rename";
    "shift-f2" = "space.rename";
    "${pick "cmd-shift" "ctrl-shift"}-p" = "app.palette";
    "${pick "cmd" "ctrl-alt"}-p" = "mod.open:picker";
    "${pick "cmd" "ctrl"}-o" = "mod.open:repo";
  }
  // forDigits (d: lib.nameValuePair "${tabSelect}-${d}" "tab.select:${d}")
  // forDigits (d: lib.nameValuePair "ctrl-${d}" "space.select:${d}")
  // forDirections (d: lib.nameValuePair "${ma}-${d}" "pane.go:${d}")
  // forDirections (d: lib.nameValuePair "${mas}-${d}" "pane.swap:${d}")
  // lib.optionalAttrs isDarwin {
    "cmd-q" = "app.quit";
    "cmd-h" = "app.hide";
    "cmd-alt-h" = "app.hide_others";
    "cmd-shift-]" = "tab.next";
    "cmd-shift-[" = "tab.prev";
  }
  // lib.optionalAttrs (!isDarwin) {
    "ctrl-shift-q" = "app.quit";
  };
  terminal = {
    "${m}-f" = "terminal.search";
    "${m}-c" = "terminal.copy";
    "${m}-v" = "terminal.paste";
    "${pick "ctrl" "ctrl-alt"}-v" = "terminal.paste_image";
    "alt-left" = "send:\u001bb";
    "alt-right" = "send:\u001bf";
    "alt-backspace" = "send:\u0017";
  }
  // lib.optionalAttrs isDarwin {
    "cmd-left" = "send:\u0001";
    "cmd-right" = "send:\u0005";
    "cmd-backspace" = "send:\u0015";
  };
}
