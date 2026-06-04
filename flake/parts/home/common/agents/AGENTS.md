# AGENTS.md

このファイルはすべてのエージェントが共有する世界のルールです。更新禁止。

## ディレクトリ定義

以降で使用する変数：

- `{agent_home}` — 当該エージェントのホームディレクトリ
  - Claude: `$CLAUDE_CONFIG_DIR`
  - Codex: `$CODEX_HOME`
- `{agent_global_home}` — エージェント間で共有するディレクトリ。常に **`$HOME/.agents/share`** とする。`{agent_home}` とは別物。
- `{project_dir_canonical}` — リポジトリのメイン作業ツリー（共有 `.git` を含むディレクトリの親）を、ホームからの相対パスにしたうえで `/` と `.` を `-` に置換した識別子。

```bash
MAIN="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
echo "$MAIN" | sed "s|^$HOME/||" | tr /. -
```

`git rev-parse --show-toplevel` は `{project_dir_canonical}` の算出に使わない。

## ファイル構造

```
{agent_global_home}/
  MEMORY.md        # エージェントチームの共通知識
  MEMORY_SUGGEST/
    {project_dir_canonical}_{YYYYMMDD}_{%03d}.md  # 長期記憶の提案
  projects/
    {project_dir_canonical}.md  # プロジェクト固有の情報
  notes/
    {foo}.md # 再利用可能な情報
  specs/  # 設計文書
    {project_dir_canonical}/
      {%03d}-{bar}.md

{agent_home}/
```

## 毎セッション開始時

以下の順で読み込む。許可を求めず実行する。

1. `{agent_global_home}/MEMORY.md`
2. `projects/{project_dir_canonical}.md`
   - 当該パスにファイルが無い場合、`projects/ghq-github-com-OWNER-REPO.md`（`git remote get-url origin` に対応する名前）を読む。
   - 本ファイルに `notes/` への参照があれば従う。

## 出力設定

- 過度な太字による強調などは使わず、簡潔な出力を心がけること
  - 質問に答える場合、具体的なコード例などより、言葉での説明を優先すること
- ユーザーの指示に対して、常に批判的な思考を持ち、必要に応じて質問を返すこと

## 作業スタイル

- コードの変更は、常に小さな単位で行うこと
- 変更内容が複数の機能や修正を含む場合は、複数のコミットに分割すること
- コードの変更は、常にテストの実装、または既存のテストの更新を伴うこと
- 大きな変更を行う場合は、必ずユーザーの承認を得ること
- エラーが発生した場合は、根本的な原因を特定した上で修正すること
