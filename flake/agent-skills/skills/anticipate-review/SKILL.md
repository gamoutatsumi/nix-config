---
name: anticipate-review
description: 蓄積されたレビュー観点（対象レビュアー 1 人分）を使って現在のgit diffをセルフレビューするスキル。push前のセルフチェック、PR作成前の品質確認に必須。「レビューしてみて」「セルフレビュー」「PR出す前にチェック」「anticipate-review」「先読みレビュー」「観点で見て」「チームのレビュー観点で」と言われたら必ず起動する。git リポジトリで作業中なら、ユーザーが明示しなくても積極的に提案すること。Use when the user wants code review, self-review, or pre-push quality check.
metadata:
  version: 0.1.0
---

# anticipate-review

対象 org の過去PRから蓄積されたレビュー観点（対象レビュアー 1 人分）を使って、現在のブランチの差分をセルフレビューするスキル。「後でそのレビュアーに指摘されそうなこと」を push 前に先回りして検出することが目的。

## 前提条件

- `git` コマンドが使えること
- カレントディレクトリが git リポジトリであること
- `gh` CLI は任意（PR がある場合、base ブランチ特定に使う）

## References（毎回必ず読む）

- `references/criteria-catalog.md` — 観点インデックス。**起動時に必ず最初に読む**
- `references/scope-rules.md` — オペレーション系 PR の判定基準

diff の性質に応じて追加で読む（criteria-catalog.md 参照後に判断）:

- `references/criteria.md` — レビュー観点の詳細（整合性・網羅性など）
- `references/output-template.md` — 出力フォーマット詳細（レビュー結果を書くときに参照）

## ワークフロー

### Step 1: diff を取得する

```bash
# PR がある場合は base ブランチを特定
gh pr view --json baseRefName 2>/dev/null

# base を origin/main と仮定する場合（PR なし）
git merge-base origin/main HEAD
git diff $(git merge-base origin/main HEAD)...HEAD

# diff が大きすぎる場合（500行超）はまずファイル一覧を確認
git diff --stat $(git merge-base origin/main HEAD)...HEAD
```

500行を超える diff の場合は、`git diff --stat` で変更の大きいファイル上位 5 件に絞ってレビューすること。

### Step 2: scope-rules.md でスコープ判定

`references/scope-rules.md` を読み、以下を判断する:

- **オペレーション系**（リソース削除・lock ファイル更新・設定値変更のみ）→ 短い終了メッセージを出して終了
- **通常のコード変更** → Step 3 へ進む
- **混在**（コードとオペレーション両方）→ コード変更部分のみを対象に Step 3 へ進む

### Step 3: criteria-catalog.md を読み、追加 references を決定

`references/criteria-catalog.md` を読む。diff の変更内容（言語・ファイル種別・変更の性質）を見て、照合すべきカテゴリを特定し、対応する `references/criteria-*.md` を読む。

全カテゴリを機械的に照合する必要はない。diff の内容に関係しそうなカテゴリのみを選ぶこと。

### Step 4: 観点照合

選んだ criteria ファイルを読みながら、diff の各変更を精査する。

指摘候補を見つけたら以下の情報をメモする:

```
{
  "criterion_id": "C-001",
  "severity": "Medium",
  "file": "<対象ファイルパス>",
  "line_hint": "<行番号>付近",
  "rationale": "<なぜ問題かの説明>"
}
```

**重要なガイドライン**:

- criteria に載っていない観点で指摘しない（この制約が存在するのは、学習データに基づく再現性を保つため）
- 該当コードが diff にない場合、既存コードにあっても指摘しない（diff のレビューであって既存コードのレビューではない）
- False positive より false negative を選ぶ。確信が持てない場合は指摘しないか、"Suggestion" 扱いにする

### Step 5: output-template.md に従って Markdown 出力

`references/output-template.md` を読み、そのフォーマットに従ってターミナルに Markdown を出力する。

ファイルへの書き出しは不要。会話に出力するだけでよい。

## 注意事項

- **観点 ID を必ず添える**: 指摘には必ず `[C-001]` 形式の ID を付ける。これにより観点の根拠が追跡可能になる
- **Context を添える**: なぜこれが問題なのかの理由（criteria の rationale 相当）を必ず書く
- **過剰な指摘をしない**: 小さな PR で全カテゴリを照合する必要はない
- **指摘がない場合は明示する**: 「観点照合の結果、指摘なし」を明記すること

## 観点の更新方法

新たなレビュー傾向が確認されたら `references/criteria.md` に C-006 以降を追記する。
`references/criteria-catalog.md` のインデックスも合わせて更新すること。
