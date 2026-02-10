import * as k from "karabiner_ts";
import * as devices from "./devices.ts";

k.writeToProfile(
  { name: "Default profile", karabinerJsonPath: "./karabiner.json" },
  [
    k
      .rule("Caps Lock -> Left Control")
      .manipulators([
        k
          .map({ key_code: "caps_lock", modifiers: { optional: ["any"] } })
          .to({ key_code: "left_control" }),
      ]),

    k
      .rule("Tap Space to Space or Left Shift", devices.isAppleInternalKeyboard)
      .manipulators([
        k.withMapper<"spacebar">(["spacebar"] as const)((spacebar) =>
          k
            .map({ key_code: spacebar, modifiers: { optional: ["any"] } })
            .to({ key_code: "left_shift" })
            .toIfAlone({ key_code: spacebar })
            .description(
              `Tap ${spacebar} alone to send Space, hold to act as Left Shift`,
            )
        ),
      ]),

    k
      .rule("Tap CMD to toggle Kana/Eisuu", devices.isAppleInternalKeyboard)
      .manipulators([
        k.withMapper<k.ModifierKeyCode, k.JapaneseKeyCode>(
          {
            left_command: "japanese_eisuu",
            right_command: "japanese_kana",
          } as const,
        )((cmd, lang) =>
          k
            .map({ key_code: cmd, modifiers: { optional: ["any"] } })
            .to({ key_code: cmd, lazy: true })
            .toIfAlone({ key_code: lang })
            .description(`Tap ${cmd} alone to switch to ${lang}`)
            .parameters({
              "basic.to_if_held_down_threshold_milliseconds": 100,
            })
        ),
      ]),
  ],
);
