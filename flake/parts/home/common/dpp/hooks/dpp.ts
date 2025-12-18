import { ContextBuilder, Plugin } from "@shougo/dpp-vim/types";
import { BaseConfig, ConfigReturn } from "@shougo/dpp-vim/config";
import { Dpp } from "@shougo/dpp-vim/dpp";
import { convert2List, parseHooksFile } from "@shougo/dpp-vim/utils";
import type { Denops } from "@denops/std";
import { assert, is } from "@core/unknownutil";

async function fennelCompile(denops: Denops, text: string): Promise<string> {
  const compiled = await denops.call(
    "luaeval",
    `require'fennel'.install().compileString(_A)`,
    text.trim(),
  );
  assert(compiled, is.String);

  return compiled;
}

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const hasNvim = args.denops.meta.host === "nvim";
    const ghCommand = new Deno.Command("gh", { args: ["auth", "token"] });
    const ghOutput = await ghCommand.output();
    const ghToken = new TextDecoder().decode(ghOutput.stdout).trim();
    args.contextBuilder.setGlobal({
      extParams: {
        installer: {
          githubAPIToken: ghToken,
        },
      },
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      },
      protocols: ["git"],
      skipMergeFilenamePattern: "^deno.jsonc?$",
    });

    type Toml = {
      hooks_file?: string | string[];
      ftplugins?: Record<string, string>;
      plugins?: Plugin[];
    };

    type LazyMakeStateResult = {
      plugins: Plugin[];
      stateLines: string[];
    };

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomls: Toml[] = [];

    for (
      const toml of [
        "@dpp_toml@",
        "@merge_toml@",
        hasNvim ? "@treesitter_toml@" : null,
        hasNvim ? "@nvim_lsp_toml@" : "@vim_lsp_toml@",
        hasNvim ? "@neovim_toml@" : "@vim_toml@",
        "@denops_toml@",
        "@ddc_toml@",
        "@ddu_toml@",
        "@ddt_toml@",
      ].filter(is.String)
    ) {
      tomls.push(
        (await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: toml,
            options: {
              lazy: false,
            },
          },
        )) as Toml,
      );
    }

    for (
      const toml of [
        "@lazy_toml@",
      ].filter(is.String)
    ) {
      tomls.push(
        (await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: toml,
            options: {
              lazy: true,
              merged: false,
            },
          },
        )) as Toml,
      );
    }

    for (
      const toml of [
        hasNvim ? "@neotest_toml@" : null,
        hasNvim ? "@nvim_lua_toml@" : null,
        hasNvim ? "@nvim_dap_toml@" : null,
      ].filter(is.String)
    ) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: toml,
            options: {
              lazy: false,
              local: true,
              merged: false,
              protocols: [],
              extParams: { installer: { installerFrozen: true } },
            },
          },
        ) as Toml,
      );
    }

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};

    tomls.forEach((toml) => {
      for (const plugin of toml.plugins ?? []) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }
    });

    const packSpecPlugins = (await args.dpp.extAction(
      args.denops,
      context,
      options,
      "packspec",
      "load",
      {
        basePath: args.basePath,
        plugins: Object.values(recordPlugins),
      },
    )) as Plugin[] | undefined;

    if (packSpecPlugins) {
      for (const plugin of packSpecPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }
    const plugins = await Promise.all(
      Object.values(recordPlugins).map(async (plugin) => {
        for (const hooksFile of convert2List(plugin.hooks_file)) {
          const hooksFilePath = (await args.denops.call(
            "dpp#util#_expand",
            hooksFile,
          )) as string;
          const hooksFileLines = (await Deno.readTextFile(hooksFilePath)).split(
            "\n",
          );

          const hooks = parseHooksFile(options.hooksFileMarker, hooksFileLines);
          plugin = Object.assign(plugin, hooks);
        }
        plugin.hooks_file = undefined;
        return plugin;
      }),
    );

    const compiledPlugins = await Promise.all(
      plugins.map(async (plugin) => {
        if (!plugin.ftplugin) {
          return plugin;
        }
        if (is.String(plugin.ftplugin.fennel_add)) {
          plugin.lua_add = await fennelCompile(
            args.denops,
            plugin.ftplugin.fennel_add,
          );
          delete plugin.ftplugin.fennel_add;
        }
        if (is.String(plugin.ftplugin.fennel_source)) {
          plugin.lua_source = await fennelCompile(
            args.denops,
            plugin.ftplugin.fennel_source,
          );
          delete plugin.ftplugin.fennel_source;
        }
        if (is.String(plugin.ftplugin.fennel_post_source)) {
          plugin.lua_post_source = await fennelCompile(
            args.denops,
            plugin.ftplugin.fennel_post_source,
          );
          delete plugin.ftplugin.fennel_post_source;
        }
        return plugin;
      }),
    );

    const lazyResult = (await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: compiledPlugins,
      },
    )) as LazyMakeStateResult | undefined;

    const checkFiles: string[] = [];
    return {
      checkFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
      ftplugins,
    };
  }
}
