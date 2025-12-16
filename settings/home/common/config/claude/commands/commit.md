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
  # Codex MCP Server - コード分析（複雑な変更の場合）
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
- 複雑な変更の場合はCodex MCPでコード分析を行う

### 良いコミットの例

- ✅ 単一機能の追加: `feat: メニュー取得APIを実装`
- ✅ 単一バグの修正: `fix: ログイン時のセッションエラーを修正`
- ✅ 関連するリファクタリング: `refactor: 認証ロジックを共通化`

### 避けるべきコミットの例

- ❌ 複数の無関係な変更:
  `feat: ログイン機能追加、メニュー表示修正、READMEリファクタリング`
- ❌ 大きすぎる変更: `feat: 連携機能全体を実装`
- ❌ 小さすぎる変更: `fix: タイポ修正` (複数のタイポはまとめる)

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

### 実行例

```
# 1. 変更内容を確認
mcp__git__git_status(repo_path=".")
mcp__git__git_diff_unstaged(repo_path=".")

# 2. 関連する変更のみをステージング
mcp__git__git_add(repo_path=".", files=["packages/agent/src/tools/weather.ts", "packages/agent/src/types/weather.ts"])

# 3. ステージング内容を確認
mcp__git__git_diff_staged(repo_path=".")

# 4. コミット
mcp__git__git_commit(repo_path=".", message="feat(agent): 天気取得ツールを追加")

# 5. 別の変更を別コミットで
mcp__git__git_add(repo_path=".", files=["packages/web/app/routes/weather.tsx"])
mcp__git__git_commit(repo_path=".", message="feat(web): 天気表示画面を実装")
```
