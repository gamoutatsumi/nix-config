---
name: using-codex
description: cmux環境内でOpenAI Codex CLIをサブエージェントとして起動・制御するスキル。並列タスク実行、タスク委任、結果回収に使用。CMUX_* 環境変数が存在し、Codexを使いたい場合にトリガー。
---

# Using Codex CLI

Codex CLIはOpenAIのAIコーディングアシスタント。cmuxのペイン分割、コマンド送信、画面読み取りを利用してサブエージェントとして制御する。
`CMUX_SOCKET_PATH` 環境変数が存在すればcmux内で動作している。

## Quick Orientation

```bash
cmux identify                    # 自分のワークスペース・サーフェスを確認
cmux list-workspaces             # 全ワークスペース一覧
cmux tree                        # トポロジー表示（階層構造）
codex version                    # Codex CLIのバージョン確認
```

リソースは短縮refsで参照する: `window:1`, `workspace:2`, `pane:3`, `surface:4`。
`--id-format uuids` でUUID形式の出力も可能。

## 基本操作

| 操作               | コマンド                                              |
| ------------------ | ----------------------------------------------------- |
| 非対話実行（推奨） | `codex exec "prompt"`                                 |
| 対話モード起動     | `codex --yolo`                                        |
| ペイン分割         | `cmux new-split right` (left/up/down も可)            |
| 新ワークスペース   | `cmux new-workspace --cwd $(pwd)`                     |
| コマンド送信       | `cmux send --surface surface:N "command\n"`           |
| 画面読み取り       | `cmux read-screen --surface surface:N [--scrollback]` |
| サーフェス/WS 終了 | `cmux close-surface` / `cmux close-workspace`         |

## Codex CLI 基本

### 実行モード

| モード             | コマンド              | 用途                                 |
| ------------------ | --------------------- | ------------------------------------ |
| **非対話（推奨）** | `codex exec "prompt"` | サブエージェント向け、結果取得が容易 |
| 対話               | `codex`               | インタラクティブな作業               |

### 主要オプション

| オプション              | 説明                                                                   |
| ----------------------- | ---------------------------------------------------------------------- |
| `--yolo`                | 全承認スキップ（`--dangerously-bypass-approvals-and-sandbox`の短縮形） |
| `--full-auto`           | 自動実行モード（ワークスペース内は自動、外部は確認）                   |
| `--cd, -C`              | 作業ディレクトリ指定                                                   |
| `-m, --model`           | モデル指定                                                             |
| `--json`                | JSON形式で出力（パース向け）                                           |
| `--output-last-message` | 最終メッセージをファイルに保存                                         |

### 終了コマンド

| コマンド | 説明                                |
| -------- | ----------------------------------- |
| `/exit`  | セッション終了                      |
| `/quit`  | セッション終了（/exitのエイリアス） |
| `Ctrl+C` | 即時終了                            |

## cross-workspace 操作の注意（重要）

別ワークスペースのサーフェスを操作する場合、**`--surface` ではなく `--workspace` を使う**。

```bash
# ✅ 正しい方法 — --workspace で指定（focused surface に自動解決）
cmux send --workspace workspace:N "command\n"
cmux read-screen --workspace workspace:N

# ❌ 間違い — --surface で他ワークスペースのサーフェスを指定
cmux send --surface surface:S "command\n"        # → "Surface is not a terminal" エラー
```

**理由**: `--surface` はcallerと同一ワークスペース内のサーフェスのみ有効。他ワークスペースのサーフェスを指定するとエラーになる。`--workspace` はワークスペースのfocused surfaceに自動解決され、cross-workspaceでも正しく動作する。

## ペイン再利用の原則

新しいペイン/ワークスペースを作る前に、ユーザーがclear済みの遊休ペインを探して再利用する。

```bash
cmux list-pane-surfaces                          # 全サーフェス一覧
screen=$(cmux read-screen --surface surface:N)   # 各サーフェスの状態を確認
# シェルプロンプト（$ や ❯）のみ → 遊休 → 再利用可能
```

遊休ペインがなければ通常通り `new-split` / `new-workspace` で作成する。

## サブエージェント操作パターン（codex exec）

**推奨**: 非対話モード（`codex exec`）を使う。プロセス終了で完了検出でき、結果取得が容易。

### 配置方式の選択

| 方式                                   | 利点                                       | 注意                                    |
| -------------------------------------- | ------------------------------------------ | --------------------------------------- |
| **同一ワークスペース** (`new-split`)   | `--surface` で直接操作可能、PTY問題なし    | レイアウトが崩れたら `cmux-grid` で修復 |
| **別ワークスペース** (`new-workspace`) | `close-workspace` で一括終了、識別しやすい | PTY遅延初期化問題の影響あり             |

### Step 1: ペイン/ワークスペース作成

#### 同一ワークスペースに配置（推奨）

```bash
SURF=$(cmux new-split right | awk '{print $2}')
cmux rename-tab --surface $SURF "Codex-Task1"
```

#### 別ワークスペースに配置

```bash
WS=$(cmux new-workspace --cwd $(pwd) | awk '{print $2}')
cmux rename-workspace --workspace $WS "Codex-Task1"
```

> **注意**: PTY遅延初期化問題により、ワークスペースをGUI上で一度表示する必要がある場合がある（using-cmuxスキルの該当セクション参照）。

### Step 2: codex exec 実行

```bash
# 基本パターン
cmux send --workspace $WS "codex exec --yolo \"タスクの指示\"\n"

# 作業ディレクトリ指定
cmux send --workspace $WS "codex exec --yolo --cd $(pwd) \"タスクの指示\"\n"

# 結果をファイルに保存
cmux send --workspace $WS "codex exec --yolo \"タスク\" --output-last-message result.txt\n"
```

> `--yolo` は信頼できるタスクにのみ使うこと。より安全なオプション: `--full-auto`

### Step 3: 完了検出

`codex exec` はプロセス終了で完了する。シェルプロンプトの再表示を `read-screen` でポーリングして検出。

```bash
# ポーリングループ
while true; do
  screen=$(cmux read-screen --workspace $WS)
  if echo "$screen" | grep -E '[$❯]' | tail -1 | grep -qE '[$❯]\s*$'; then
    break
  fi
  sleep 2
done
```

### Step 4: 結果回収

```bash
result=$(cmux read-screen --workspace $WS --scrollback)  # 全出力取得

# --output-last-message を使った場合はファイルから読み取り
# result=$(cat result.txt)
```

### Step 5: クリーンアップ

```bash
cmux close-workspace --workspace $WS  # ワークスペースごと閉じる
# または
cmux close-surface --surface $SURF    # サーフェスのみ閉じる
```

## 並列実行パターン

複数のCodexインスタンスを並列起動し、タスクを同時処理。

```bash
# タスクリスト
tasks=("タスク1" "タスク2" "タスク3")
declare -A workspaces

# 並列起動
for i in "${!tasks[@]}"; do
  WS=$(cmux new-workspace --cwd $(pwd) | awk '{print $2}')
  cmux rename-workspace --workspace $WS "Codex-$i"
  cmux send --workspace $WS "codex exec --yolo \"${tasks[$i]}\"\n"
  workspaces[$i]=$WS
done

# 完了待機
for i in "${!workspaces[@]}"; do
  WS="${workspaces[$i]}"
  cmux set-status "task-$i" "実行中" --icon hammer

  while true; do
    screen=$(cmux read-screen --workspace $WS)
    if echo "$screen" | grep -E '[$❯]' | tail -1 | grep -qE '[$❯]\s*$'; then
      break
    fi
    sleep 2
  done

  cmux clear-status "task-$i"
done

# 結果回収
for i in "${!workspaces[@]}"; do
  WS="${workspaces[$i]}"
  result=$(cmux read-screen --workspace $WS --scrollback)
  echo "=== Task $i Result ==="
  echo "$result"
  cmux close-workspace --workspace $WS
done
```

## 対話モード（補足）

長時間の会話や途中経過の監視が必要な場合は対話モードを使用。

### Step 1: ペイン作成（同じ）

```bash
WS=$(cmux new-workspace --cwd $(pwd) | awk '{print $2}')
```

### Step 2: Codex 起動

```bash
cmux send --workspace $WS "codex --yolo\n"
```

### Step 3: 起動完了の検出

Codexプロンプト（通常は `>` や TUI表示）が表示されるまで `read-screen` でポーリング。

```bash
while true; do
  screen=$(cmux read-screen --workspace $WS)
  if echo "$screen" | grep -q "Codex"; then  # または他の起動完了パターン
    break
  fi
  sleep 1
done
```

### Step 4: プロンプト送信

```bash
# 単一行
cmux send --workspace $WS "指示テキスト\n"

# 複数行（send-key return で改行）
cmux send --workspace $WS "1行目の指示"
cmux send-key --workspace $WS return
cmux send --workspace $WS "2行目の指示"
cmux send-key --workspace $WS return
```

### Step 5: 完了検出

Codexプロンプトの再表示を `read-screen` でポーリング。

### Step 6: 終了

```bash
cmux send --workspace $WS "/exit\n"
sleep 2
cmux close-workspace --workspace $WS
```

## ロングラン実行の監視

dev serverやビルドなど長時間プロセスは専用ペインに分離し、`read-screen` で定期的に監視する。

```bash
cmux new-split right              # → surface:N
cmux send --surface surface:N "codex exec --yolo 'npm run dev'\n"
# ポーリングで "ready" 等のキーワードを検出
screen=$(cmux read-screen --surface surface:N)
```

## 通知

```bash
# アプリ内通知（ペインハイライト、サイドバーバッジ）
cmux notify --title "完了" --body "Codexタスクが完了しました"

# macOS 通知センター（別アプリ使用中でも表示）
osascript -e 'display notification "Codexタスク完了" with title "Codex" sound name "Glass"'
```

使い分け: cmux内で注意を引く → `cmux notify`、ユーザーが別アプリにいる → `osascript`。

## ステータス・プログレス表示

```bash
cmux set-status mykey "Codex実行中" --icon hammer --color "#0099ff"
cmux clear-status mykey
cmux set-progress 0.5 --label "処理中..."  # 0.0〜1.0
cmux clear-progress
```

## read-screen トラブルシューティング

| 問題                        | 対処                                       |
| --------------------------- | ------------------------------------------ |
| 出力が空 / 古い             | `cmux refresh-surfaces` してから再読み取り |
| 長い出力が切れる            | `--scrollback` を追加                      |
| 特定行数だけ欲しい          | `--lines N` で行数指定                     |
| surface が見つからない      | `cmux list-pane-surfaces` で refs を再確認 |
| `Surface is not a terminal` | PTY遅延初期化問題。using-cmuxスキル参照    |

## よくあるミス

| ミス                                        | 正しい方法                                                |
| ------------------------------------------- | --------------------------------------------------------- |
| `codex exec` の完了を検出せず即座に結果取得 | プロンプト再表示をポーリングして完了を検出                |
| UUID でサーフェスを指定する                 | 短縮 refs を使う: `surface:1`, `pane:2`                   |
| `--surface` で他ワークスペースを操作        | `--workspace` を使う（cross-workspace 操作の注意 参照）   |
| 遊休ペインがあるのに新しく split する       | `list-pane-surfaces` + `read-screen` で遊休ペインを再利用 |
| ワークスペースに名前を付けない              | `rename-workspace` で用途を示す名前を付ける               |
| クリーンアップを忘れる                      | タスク終了後は必ず `close-workspace` / `close-surface`    |
| `--yolo` を無条件に使う                     | 信頼できるタスクのみに使用、それ以外は `--full-auto`      |

## コマンドクイックリファレンス

| コマンド                                 | 説明                         |
| ---------------------------------------- | ---------------------------- |
| `codex exec "prompt"`                    | 非対話実行（推奨）           |
| `codex --yolo`                           | 対話モード（全承認スキップ） |
| `codex exec --json`                      | JSON形式で出力               |
| `/exit` / `/quit`                        | 対話モード終了               |
| `cmux identify` / `tree`                 | 環境情報 / トポロジー表示    |
| `cmux new-workspace` / `new-split`       | ワークスペース・ペイン作成   |
| `cmux send` / `read-screen`              | 入出力操作                   |
| `cmux close-workspace` / `close-surface` | リソース終了                 |
| `cmux notify` / `set-status`             | 通知・ステータス             |

## 環境変数

| 変数                | 説明                                            |
| ------------------- | ----------------------------------------------- |
| `CMUX_SOCKET_PATH`  | cmux ソケットのパス。存在すれば cmux 内で動作中 |
| `CMUX_WORKSPACE_ID` | 現在のワークスペース ID                         |
| `CMUX_SURFACE_ID`   | 現在のサーフェス ID                             |
