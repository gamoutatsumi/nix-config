---
description: Commit changes with appropriate granularity
allowed-tools:
  - Bash(git add:*)
  - Bash(git commit:*)
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git log:*)
---

## 適切なコミット粒度

### 基本原則

- 1つのコミットには1つの論理的な変更のみを含める
- 関連する変更はまとめて、無関係な変更は分離する
- コミットメッセージから変更内容が明確に理解できる粒度にする
- 過去のコミットメッセージを参照し、英語または日本語によるコミットメッセージを使い分ける

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

### 実行例

```bash
# 変更内容を確認
git status
git diff

# 関連する変更のみをステージング
git add packages/agent/src/tools/weather.ts
git add packages/agent/src/types/weather.ts

# コミット
git commit -m "feat(agent): 天気取得ツールを追加"

# 別の変更を別コミットで
git add packages/web/app/routes/weather.tsx
git commit -m "feat(web): 天気表示画面を実装"
```
