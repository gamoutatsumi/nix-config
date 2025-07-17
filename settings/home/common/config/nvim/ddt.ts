import { BaseConfig } from "jsr:@shougo/ddt-vim@1.0.0/config";

export class Config extends BaseConfig {
  override config({ contextBuilder, denops: _denops }) {
    contextBuilder.patchGlobal({
      ui: "terminal",
      uiParams: {
        terminal: {
          split: "horizontal",
          size: 15,
          direction: "botright",
          focus: true,
          closeOnExit: true,
        },
      },
    });
  }
}
