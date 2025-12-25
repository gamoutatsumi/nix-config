---
description: "Review a Pull Request (PR Number Required)"
allowed-tools:
# 基本ツール
- Read
- Glob
- Grep
# GitHub MCP Server - ツールセット管理
- mcp__github__list_available_toolsets
- mcp__github__get_toolset_tools
- mcp__github__enable_toolset
# GitHub MCP Server - PR情報取得（pull_requestsツールセット有効化後に使用可能）
- mcp__github__pull_request_read
- mcp__github__list_pull_requests
- mcp__github__search_pull_requests
# GitHub MCP Server - ユーザー情報（contextツールセット有効化後に使用可能）
- mcp__github__get_me
# Git MCP Server - ローカルリポジトリ操作
- mcp__git__git_status
- mcp__git__git_log
- mcp__git__git_diff
- mcp__git__git_branch
- mcp__git__git_show
# Serena MCP Server - コード分析
- mcp__serena__activate_project
- mcp__serena__get_symbols_overview
- mcp__serena__find_symbol
- mcp__serena__find_referencing_symbols
- mcp__serena__search_for_pattern
- mcp__serena__list_dir
- mcp__serena__find_file
# Context7 MCP Server - ライブラリドキュメント参照
- mcp__context7__resolve-library-id
- mcp__context7__get-library-docs
# Sequential-Thinking MCP Server - 深い検討
- mcp__sequential-thinking__sequentialthinking
# Codex MCP Server - 複雑な分析タスクの委任
- mcp__codex__codex
- mcp__codex__codex-reply
---

私はこのリポジトリにおいてコードレビューを任されています。あなたは優秀なアシスタントです。

以下の手順でPull request(PR)を確認し、レビューに役立つ情報を提示してください。

# 0. 準備フェーズ

## GitHub MCP ツールセットの有効化

まず必要なツールセットを有効化します:

```
mcp__github__enable_toolset({ toolset: "pull_requests" })
mcp__github__enable_toolset({ toolset: "context" })
```

# 1. 情報収集フェーズ（直接MCPサーバーを使用）

## PRの内容確認

GitHub MCP Server
を使用して、対象PRの内容を確認します。`$ARGUMENTS`にはPRの番号が渡されます。

- `mcp__github__pull_request_read` - PRの基本情報・差分・変更ファイル一覧を取得

リポジトリのオーナーとリポジトリ名は、現在のリポジトリのリモート設定から取得してください。

## プロンプトファイルの確認

`CLAUDE.md` が存在する場合は内容を確認します。

## コード構造の分析（Serena）

変更されたコードの構造を Serena MCP Server で分析します:

- `mcp__serena__get_symbols_overview` - 変更ファイル内のシンボル構造
- `mcp__serena__find_symbol` - 特定のクラス・関数・メソッドの詳細
- `mcp__serena__find_referencing_symbols` -
  変更されたシンボルの参照元（影響範囲）

## ライブラリドキュメント参照（Context7）

変更に使用されているライブラリのベストプラクティスを確認する場合:

1. `mcp__context7__resolve-library-id` でライブラリIDを解決
1. `mcp__context7__get-library-docs` でドキュメントを取得

# 2. 分析フェーズ（Codexに委任）

収集した情報をCodexに渡し、詳細なコードレビューを委任します:

```
mcp__codex__codex({
  prompt: `
以下のPull Requestをレビューしてください。

## PRの概要
- タイトル: {PRタイトル}
- 説明: {PR説明}

## 変更ファイル
{ファイル一覧}

## 差分
{diff内容}

## シンボル構造と参照関係
{Serenaで取得した情報}

## ライブラリドキュメント（該当する場合）
{Context7で取得した情報}

## レビュー観点（CLAUDE.mdより）
{CLAUDE.mdの内容}

以上の情報をもとにしてコードベースを詳細に分析し、以下の観点でレビューしてください:
1. コードの品質と可読性
2. バグや潜在的な問題（エッジケース、エラーハンドリング）
3. セキュリティ上の懸念
4. パフォーマンスへの影響
5. プロジェクトの規約への準拠
6. 影響範囲（参照元への破壊的変更がないか）
`,
  sandbox: "workspace-write",
  approval-policy: "never"
})
```

# 3. レビュー結果の整理

Codexの分析結果を受け取り、以下の形式で整理して提示してください:

- **概要**: PRの目的と変更内容のサマリー
- **良い点**: コードの良い部分
- **懸念点**: 修正が必要な箇所、潜在的な問題
- **提案**: 改善提案

追加の分析が必要な場合は `mcp__codex__codex-reply` で対話を継続できます。
