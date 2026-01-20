---
name: planning
description: 実装計画を立案する為のスキル。Plan Subagent を実行する際に併せて使用する。
version: 0.0.1
---

# Planning Skill

## Overview

実装計画を立案する際に使用するスキル。

Plan Subagent が立案した計画を元に Codex にレビューを受けたり、改善案を提示してもらう。

## 実行コマンド

```bash
codex exec --full-auto --sandbox read-only --cd <project_directory> "<request>"
```

## パラメータ

| パラメータ            | 説明                                       |
| --------------------- | ------------------------------------------ |
| `--full-auto`         | 完全自動モードで実行                       |
| `--sandbox read-only` | 読み取り専用サンドボックス（安全な分析用） |
| `--cd <dir>`          | 対象プロジェクトのディレクトリ             |
| `"<request>"`         | 依頼内容（日本語可）                       |
| `"<plan file>"`       | Plan Subagent が作成した計画ファイル       |

## 例

```
codex exec --full-auto --sandbox read-only --cd /path/to/project "<plan file> をレビューし、改善案を提示してください。この計画は、以下の要件から構成されています：..."
```

## 実行手順

1. ユーザーから依頼内容を受け取る。
2. 通常通り Plan Subagent を実行し、計画ファイルを作成する。
3. 作成された計画ファイルを元に、Codex にレビューと改善案の提示を依頼する。
4. Codex からのフィードバックを受け取り、計画ファイルを更新する。
5. 最低でも2往復のレビューと改善を繰り返す。
6. 最終的な計画ファイルをユーザーに提供する。
