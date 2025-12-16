---
description: "Review a Pull Request (PR Number Required)"
allowed-tools:
  # 基本ツール
  - Read
  - Glob
  - Grep
  # GitHub MCP Server - PR情報取得・レビュー操作
  - mcp__github__pull_request_read
  - mcp__github__pull_request_review_write
  - mcp__github__add_comment_to_pending_review
  - mcp__github__add_issue_comment
  - mcp__github__get_me
  # Git MCP Server - ローカルリポジトリ操作
  - mcp__git__git_status
  - mcp__git__git_log
  - mcp__git__git_diff
  - mcp__git__git_branch
  - mcp__git__git_show
  # Codex MCP Server - コード分析
  - mcp__codex__codex
  - mcp__codex__codex-reply
---

私はこのリポジトリにおいてコードレビューを任されています。あなたは優秀なアシスタントです。

以下の手順でPull request(PR)を確認し、レビューに役立つ情報を提示してください。

1. 対象PRの内容確認
2. プロンプトファイルの内容確認（存在する場合）
3. Codexによるコード分析とレビュー

# 対象PRの内容確認

GitHub MCP Server
のツールを使用して、対象PRの内容を確認します。`$ARGUMENTS`にはPRの番号が渡されます。

PRの詳細情報を取得するには `mcp__github__pull_request_read` ツールを使用します:

- `method: "get"` - PRの基本情報（タイトル、説明、作成者など）
- `method: "get_diff"` - PRに含まれる差分
- `method: "get_files"` - 変更されたファイル一覧

リポジトリのオーナーとリポジトリ名は、現在のリポジトリのリモート設定から取得してください。

# プロンプトファイルの内容確認（存在する場合）

プロンプトファイル`CLAUDE.md`の内容を確認します。

# Codexによるコード分析とレビュー

Codex MCP Server を使用して、PRの詳細なコード分析を行います。

`mcp__codex__codex` ツールに以下の情報を含むプロンプトを渡してください:

- PRの差分内容
- 変更されたファイル一覧
- PRの目的・説明
- CLAUDE.mdの内容（レビュー観点として）

Codexへのプロンプト例:

```
以下のPull Requestをレビューしてください。

## PRの概要
- タイトル: {PRタイトル}
- 説明: {PR説明}

## 変更ファイル
{ファイル一覧}

## 差分
{diff内容}

## レビュー観点
{CLAUDE.mdの内容}

以下の観点でレビューを行ってください:
1. コードの品質と可読性
2. バグや潜在的な問題
3. セキュリティ上の懸念
4. パフォーマンスへの影響
5. プロジェクトの規約への準拠
```

Codexの分析結果を受け取り、私が判断する際に役立つ情報として整理して提示してください。
追加の分析が必要な場合は `mcp__codex__codex-reply`
を使用して対話を継続できます。
