---
allowed-tools:
  # 基本
  - Read(CLAUDE.md)
  - mcp__sequential-thinking__sequentialthinking
  # GitHub MCP Server - PR情報取得
  - mcp__github__pull_request_read
  - mcp__github__get_file_contents
  - mcp__github__list_commits
  - mcp__github__get_commit
  # Git MCP Server - ローカルリポジトリ操作
  - mcp__git__git_status
  - mcp__git__git_diff
  - mcp__git__git_log
  - mcp__git__git_show
  # Serena MCP Server - コード解析（読み取り専用）
  - mcp__serena__check_onboarding_performed
  - mcp__serena__read_file
  - mcp__serena__list_dir
  - mcp__serena__find_file
  - mcp__serena__search_for_pattern
  - mcp__serena__get_symbols_overview
  - mcp__serena__find_symbol
  - mcp__serena__find_referencing_symbols
  - mcp__serena__list_memories
  - mcp__serena__read_memory
  - mcp__serena__think_about_collected_information
  - mcp__serena__think_about_task_adherence
  - mcp__serena__think_about_whether_you_are_done
  # Context7 MCP Server - ドキュメント参照
  - mcp__context7__resolve-library-id
  - mcp__context7__get-library-docs
description: "Review a Pull Request (PR Number Required)"
---

私はこのリポジトリにおいてコードレビューを任されています。あなたは優秀なアシスタントです。

以下の手順でPull request(PR)を確認し、レビューに役立つ情報を提示してください。

1. 対象PRの内容確認
2. プロンプトファイルの内容確認（存在する場合）
3. コード解析とレビュー

# 対象PRの内容確認

GitHub MCP Server
のツールを使用して、対象PRの内容を確認します。`$ARGUMENTS`にはPRの番号が渡されます。

PRの詳細情報を取得するには `mcp__github__pull_request_read` ツールを使用します:

- `method: "get"` - PRの基本情報（タイトル、説明、作成者など）
- `method: "get_diff"` - PRに含まれる差分
- `method: "get_files"` - 変更されたファイル一覧
- `method: "get_reviews"` - 既存のレビュー
- `method: "get_review_comments"` - レビューコメント

リポジトリのオーナーとリポジトリ名は、現在のリポジトリのリモート設定から取得してください。

Git MCP Server のツールも活用して、コミット履歴やローカルの状態を確認できます:

- `mcp__git__git_log` - コミット履歴の確認
- `mcp__git__git_show` - 特定コミットの詳細確認
- `mcp__git__git_diff` - ブランチ間の差分確認

# プロンプトファイルの内容確認（存在する場合）

プロンプトファイル`CLAUDE.md`の内容を確認します。

# コード解析とレビュー

Serena MCP Server のツールを活用して、コードの詳細な解析を行います:

- `mcp__serena__get_symbols_overview` - ファイル内のシンボル概要を取得
- `mcp__serena__find_symbol` - 特定のシンボルを検索
- `mcp__serena__find_referencing_symbols` - シンボルの参照箇所を検索
- `mcp__serena__search_for_pattern` - パターンによるコード検索

使用しているライブラリのドキュメントを確認する必要がある場合は、Context7 MCP
Server を使用します:

- `mcp__context7__resolve-library-id` - ライブラリIDの解決
- `mcp__context7__get-library-docs` - ドキュメントの取得

対象PRの内容についてレビューを行い、私が判断する際に役立つ情報として提示してください。
レビューの観点についてはプロンプトファイルの内容を踏まえて確認してください。
