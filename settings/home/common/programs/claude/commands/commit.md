---
description: Commit changes with appropriate granularity
allowed-tools:
  # 基本ツール
  - Read
  - Glob
  - Grep
  # Git MCP Server - コミット操作
  - mcp__git__git_status
  - mcp__git__git_add
  - mcp__git__git_reset
  - mcp__git__git_diff
  - mcp__git__git_diff_unstaged
  - mcp__git__git_diff_staged
  - mcp__git__git_commit
  - mcp__git__git_log
  - mcp__git__git_branch
  - mcp__git__git_show
  # Serena MCP Server - コード分析
  - mcp__serena__read_file
  - mcp__serena__get_symbols_overview
  - mcp__serena__find_symbol
  - mcp__serena__find_referencing_symbols
  - mcp__serena__search_for_pattern
  - mcp__serena__list_dir
  # Codex MCP Server - 複雑な分析タスクの委任
  - mcp__codex__codex
  - mcp__codex__codex-reply
---

## 適切なコミット粒度

### 基本原則

- 1つのコミットには1つの論理的な変更のみを含める
- 関連する変更はまとめて、無関係な変更は分離する
- コミットメッセージから変更内容が明確に理解できる粒度にする
- 過去のコミットメッセージを参照し、英語または日本語によるコミットメッセージを使い分ける
- unstagedなファイルも含めて差分を解析する

### 良いコミットの例

- 単一機能の追加: `feat: メニュー取得APIを実装`
- 単一バグの修正: `fix: ログイン時のセッションエラーを修正`
- 関連するリファクタリング: `refactor: 認証ロジックを共通化`

### 避けるべきコミットの例

- 複数の無関係な変更:
  `feat: ログイン機能追加、メニュー表示修正、READMEリファクタリング`
- 大きすぎる変更: `feat: 連携機能全体を実装`
- 小さすぎる変更: `fix: タイポ修正` (複数のタイポはまとめる)

### コミット分割の判断基準

1. **機能的な独立性**: 他の変更なしに動作するか
2. **レビューの容易さ**: 差分が理解しやすいサイズか
3. **履歴の追跡性**: 後から特定の変更を見つけやすいか

### 実行手順

1. **変更内容を確認**: `mcp__git__git_status` と `mcp__git__git_diff_unstaged`
   を使用
2. **関連する変更のみをステージング**: `mcp__git__git_add` で関連ファイルを追加
3. **ステージング内容を確認**: `mcp__git__git_diff_staged` で確認
4. **コミット**: `mcp__git__git_commit` でコミット
5. **必要に応じて繰り返す**: 別の論理的変更は別コミットとして作成

### コード分析の手順

#### 1. 情報収集（直接MCPサーバーを使用）

まず Serena MCP Server で変更内容を分析します:

- `mcp__serena__get_symbols_overview` - 変更ファイル内のシンボル構造を把握
- `mcp__serena__find_symbol` - 特定のクラス・関数・メソッドの詳細を取得
- `mcp__serena__find_referencing_symbols` - 変更されたシンボルの参照元を確認

#### 2. 複雑な分析（Codexに委任）

変更が複雑で、コミット分割の判断が難しい場合は、収集した情報をCodexに渡して分析を委任します:

```
mcp__codex__codex({
  prompt: `
以下の変更内容を分析し、適切なコミット分割を提案してください。

## 変更ファイル
{git statusの結果}

## 差分
{git diffの結果}

## シンボル構造
{Serenaで取得したシンボル情報}

## 参照関係
{find_referencing_symbolsの結果}

以上の情報を元にコードベースを分析し、以下を判断してください:
1. 変更の論理的なグループ分け
2. 各グループの依存関係
3. 推奨するコミット順序とメッセージ
`,
  sandbox: "workspace-write",
  approval-policy: "never"
})
```

追加の分析が必要な場合は `mcp__codex__codex-reply` で対話を継続できます。
