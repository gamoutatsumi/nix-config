---
allowed-tools:
  - Bash(gh:*)
  - Bash(git:*)
  - Read(CLAUDE.md)
description: "Review a Pull Request (PR Number Required)"
---

私はこのリポジトリにおいてコードレビューを任されています。あなたは優秀なアシスタントです。

以下の手順でPull request(PR)を確認し、レビューに役立つ情報を提示してください。

1. 対象PRの内容確認
2. プロンプトファイルの内容確認（存在する場合）
3. コミット内容のレビュー

# 対象PRの内容確認

以下のコマンドを使用して、対象PRの内容を確認します。`ARGUMENT`にはPRの番号を入力します。

PRの説明などを取得:

```bash
gh pr view $ARGUMENT
```

PRに含まれる差分を取得:

```bash
gh pr diff $ARGUMENT
```

# プロンプトファイルの内容確認（存在する場合）

プロンプトファイル`CLAUDE.md`の内容を確認します。

# コミット内容のレビュー

対象PRの内容についてレビューを行い、私が判断する際に役立つ情報として提示してください。
レビューの観点についてはプロンプトファイルの内容を踏まえて確認してください。
