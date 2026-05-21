---
name: long-memory
description: Provides long-term memory for agents. Use when an agent needs to remember information across multiple
---

# Long Memory

次の各ファイルに対する更新案を `MEMORY_SUGGEST/{project_dir_canonical}_{YYYYMMDD}_{%03d}.md` にまとめる（`%03d` は未使用の連番）。

- `{agent_global_home}/MEMORY.md`
- `projects/{project_dir_canonical}.md`
- `notes/{foo}.md`（トピックごとに `{foo}` を定める）

ただし、プロジェクト固有メモ (`projects/{project_dir_canonical}.md`) については、ユーザーから別途禁止されていない限り、直接編集してよい。

- 長期記憶として書き出すファイル (`projects/{project_dir_canonical}.md`、`notes/{foo}.md`、`MEMORY_SUGGEST/` 配下) は日本語で記述する。
- 直接編集したプロジェクト固有メモの内容は、記憶の提案ファイルには重複して書かない。
- 提案として書く内容が無い場合は、`MEMORY_SUGGEST/` にファイルを作成しなくてよい。
- 複数プロジェクトの作業をした場合は、対象プロジェクトごとに直接編集または記憶の提案を行う。
- ユーザーから受けた指摘は、以後のアウトプット品質を改善する重要な知識として扱い、プロジェクト固有メモや notes へ積極的に反映する。
