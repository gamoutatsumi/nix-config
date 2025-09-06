import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddc-vim@10.1.0/config";

const CONVERTERS = [
  "converter_fuzzy",
  "converter_remove_overlap",
  "converter_truncate_abbr",
];

export class Config extends BaseConfig {
  override config({ contextBuilder, denops }: ConfigArguments): Promise<void> {
    contextBuilder.patchGlobal({
      ui: "pum",
      sources: ["denippet", "copilot", "file", "lsp", "around"],
      filterParams: {
        converter_kind_labels: {
          kindLabels: {
            Text: "󰉿",
            Method: "󰆧",
            Function: "󰊕",
            Constructor: "",
            Field: "󰜢",
            Variable: "󰀫",
            Class: "󰠱",
            Interface: "",
            Module: "",
            Property: "󰜢",
            Unit: "󰑭",
            Value: "󰎠",
            Enum: "",
            Keyword: "󰌋",
            Snippet: "",
            Color: "󰏘",
            File: "󰈙",
            Reference: "󰈇",
            Folder: "󰉋",
            EnumMember: "",
            Constant: "󰏿",
            Struct: "󰙅",
            Event: "",
            Operator: "󰆕",
            TypeParameter: "",
          },
          kindHlGroups: {
            Method: "Function",
            Function: "Function",
            Constructor: "Function",
            Field: "Identifier",
            Variable: "Identifier",
            Class: "Structure",
            Interface: "Structure",
          },
        },
      },
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineChanged",
      ],
      cmdlineSources: {
        ":": ["cmdline", "cmdline_history", "around"],
        "@": ["around"],
      },
      sourceParams: {
        file: {
          displayFile: "",
          displayDir: "",
        },
        copilot: {
          copilot: "lua",
        },
        lsp: {
          lspEngine: "nvim-lsp",
          enableAdditionalTextEdit: true,
          enableResolveItem: true,
          confirmBehavior: "replace",
          snippetEngine: (body: string) =>
            denops.call("denippet#anonymous", body),
        },
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_ascii", "sorter_fuzzy"],
          keywordPattern: "(\\k|-|_)*",
          converters: CONVERTERS,
        },
        copilot: {
          mark: "[Copilot]",
          matchers: [],
          minAutoCompleteLength: 0,
          isVolatile: true,
        },
        "cmdline_history": {
          mark: "[History]",
        },
        lsp: {
          mark: "[LSP]",
          ignoreCase: true,
          isVolatile: true,
          converters: [...CONVERTERS, "converter_kind_labels"],
          sorters: ["sorter_ascii", "sorter_fuzzy", "sorter_lsp-kind"],
          dup: "keep",
          keywordPattern: "\\k+",
        },
        around: {
          mark: "[Around]",
          dup: "keep",
          isVolatile: true,
        },
        denippet: {
          mark: "[Denippet]",
          dup: "keep",
          isVolatile: true,
          converters: [...CONVERTERS, "converter_kind_labels"],
          sorters: ["sorter_ascii", "sorter_fuzzy", "sorter_lsp-kind"],
        },
        file: {
          mark: "[File]",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
          ignoreCase: true,
          dup: "force",
        },
        cmdline: {
          mark: "[Cmd]",
          ignoreCase: true,
        },
      },
    });
    return Promise.resolve();
  }
}
